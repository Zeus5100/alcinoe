/*
 *  Copyright (c) 2004 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef MEDIA_BASE_FAKEMEDIAENGINE_H_
#define MEDIA_BASE_FAKEMEDIAENGINE_H_

#include <list>
#include <map>
#include <memory>
#include <set>
#include <string>
#include <tuple>
#include <vector>

#include "api/call/audio_sink.h"
#include "media/base/audiosource.h"
#include "media/base/mediaengine.h"
#include "media/base/rtputils.h"
#include "media/base/streamparams.h"
#include "media/engine/webrtcvideoengine.h"
#include "modules/audio_processing/include/audio_processing.h"
#include "rtc_base/copyonwritebuffer.h"
#include "rtc_base/networkroute.h"

using webrtc::RtpExtension;

namespace cricket {

class FakeMediaEngine;
class FakeVideoEngine;
class FakeVoiceEngine;

// A common helper class that handles sending and receiving RTP/RTCP packets.
template <class Base>
class RtpHelper : public Base {
 public:
  RtpHelper()
      : sending_(false),
        playout_(false),
        fail_set_send_codecs_(false),
        fail_set_recv_codecs_(false),
        send_ssrc_(0),
        ready_to_send_(false),
        transport_overhead_per_packet_(0),
        num_network_route_changes_(0) {}
  virtual ~RtpHelper() = default;
  const std::vector<RtpExtension>& recv_extensions() {
    return recv_extensions_;
  }
  const std::vector<RtpExtension>& send_extensions() {
    return send_extensions_;
  }
  bool sending() const { return sending_; }
  bool playout() const { return playout_; }
  const std::list<std::string>& rtp_packets() const { return rtp_packets_; }
  const std::list<std::string>& rtcp_packets() const { return rtcp_packets_; }

  bool SendRtp(const void* data,
               size_t len,
               const rtc::PacketOptions& options) {
    if (!sending_) {
      return false;
    }
    rtc::CopyOnWriteBuffer packet(reinterpret_cast<const uint8_t*>(data), len,
                                  kMaxRtpPacketLen);
    return Base::SendPacket(&packet, options);
  }
  bool SendRtcp(const void* data, size_t len) {
    rtc::CopyOnWriteBuffer packet(reinterpret_cast<const uint8_t*>(data), len,
                                  kMaxRtpPacketLen);
    return Base::SendRtcp(&packet, rtc::PacketOptions());
  }

  bool CheckRtp(const void* data, size_t len) {
    bool success = !rtp_packets_.empty();
    if (success) {
      std::string packet = rtp_packets_.front();
      rtp_packets_.pop_front();
      success = (packet == std::string(static_cast<const char*>(data), len));
    }
    return success;
  }
  bool CheckRtcp(const void* data, size_t len) {
    bool success = !rtcp_packets_.empty();
    if (success) {
      std::string packet = rtcp_packets_.front();
      rtcp_packets_.pop_front();
      success = (packet == std::string(static_cast<const char*>(data), len));
    }
    return success;
  }
  bool CheckNoRtp() { return rtp_packets_.empty(); }
  bool CheckNoRtcp() { return rtcp_packets_.empty(); }
  void set_fail_set_send_codecs(bool fail) { fail_set_send_codecs_ = fail; }
  void set_fail_set_recv_codecs(bool fail) { fail_set_recv_codecs_ = fail; }
  virtual bool AddSendStream(const StreamParams& sp) {
    if (std::find(send_streams_.begin(), send_streams_.end(), sp) !=
        send_streams_.end()) {
      return false;
    }
    send_streams_.push_back(sp);
    rtp_send_parameters_[sp.first_ssrc()] =
        CreateRtpParametersWithEncodings(sp);
    return true;
  }
  virtual bool RemoveSendStream(uint32_t ssrc) {
    auto parameters_iterator = rtp_send_parameters_.find(ssrc);
    if (parameters_iterator != rtp_send_parameters_.end()) {
      rtp_send_parameters_.erase(parameters_iterator);
    }
    return RemoveStreamBySsrc(&send_streams_, ssrc);
  }
  virtual bool AddRecvStream(const StreamParams& sp) {
    if (std::find(receive_streams_.begin(), receive_streams_.end(), sp) !=
        receive_streams_.end()) {
      return false;
    }
    receive_streams_.push_back(sp);
    rtp_receive_parameters_[sp.first_ssrc()] =
        CreateRtpParametersWithOneEncoding();
    return true;
  }
  virtual bool RemoveRecvStream(uint32_t ssrc) {
    auto parameters_iterator = rtp_receive_parameters_.find(ssrc);
    if (parameters_iterator != rtp_receive_parameters_.end()) {
      rtp_receive_parameters_.erase(parameters_iterator);
    }
    return RemoveStreamBySsrc(&receive_streams_, ssrc);
  }

  virtual webrtc::RtpParameters GetRtpSendParameters(uint32_t ssrc) const {
    auto parameters_iterator = rtp_send_parameters_.find(ssrc);
    if (parameters_iterator != rtp_send_parameters_.end()) {
      return parameters_iterator->second;
    }
    return webrtc::RtpParameters();
  }
  virtual webrtc::RTCError SetRtpSendParameters(
      uint32_t ssrc,
      const webrtc::RtpParameters& parameters) {
    auto parameters_iterator = rtp_send_parameters_.find(ssrc);
    if (parameters_iterator != rtp_send_parameters_.end()) {
      auto result =
          ValidateRtpParameters(parameters_iterator->second, parameters);
      if (!result.ok())
        return result;

      parameters_iterator->second = parameters;
      return webrtc::RTCError::OK();
    }
    // Replicate the behavior of the real media channel: return false
    // when setting parameters for unknown SSRCs.
    return webrtc::RTCError(webrtc::RTCErrorType::INTERNAL_ERROR);
  }

  virtual webrtc::RtpParameters GetRtpReceiveParameters(uint32_t ssrc) const {
    auto parameters_iterator = rtp_receive_parameters_.find(ssrc);
    if (parameters_iterator != rtp_receive_parameters_.end()) {
      return parameters_iterator->second;
    }
    return webrtc::RtpParameters();
  }
  virtual bool SetRtpReceiveParameters(
      uint32_t ssrc,
      const webrtc::RtpParameters& parameters) {
    auto parameters_iterator = rtp_receive_parameters_.find(ssrc);
    if (parameters_iterator != rtp_receive_parameters_.end()) {
      parameters_iterator->second = parameters;
      return true;
    }
    // Replicate the behavior of the real media channel: return false
    // when setting parameters for unknown SSRCs.
    return false;
  }

  bool IsStreamMuted(uint32_t ssrc) const {
    bool ret = muted_streams_.find(ssrc) != muted_streams_.end();
    // If |ssrc = 0| check if the first send stream is muted.
    if (!ret && ssrc == 0 && !send_streams_.empty()) {
      return muted_streams_.find(send_streams_[0].first_ssrc()) !=
             muted_streams_.end();
    }
    return ret;
  }
  const std::vector<StreamParams>& send_streams() const {
    return send_streams_;
  }
  const std::vector<StreamParams>& recv_streams() const {
    return receive_streams_;
  }
  bool HasRecvStream(uint32_t ssrc) const {
    return GetStreamBySsrc(receive_streams_, ssrc) != nullptr;
  }
  bool HasSendStream(uint32_t ssrc) const {
    return GetStreamBySsrc(send_streams_, ssrc) != nullptr;
  }
  // TODO(perkj): This is to support legacy unit test that only check one
  // sending stream.
  uint32_t send_ssrc() const {
    if (send_streams_.empty())
      return 0;
    return send_streams_[0].first_ssrc();
  }

  // TODO(perkj): This is to support legacy unit test that only check one
  // sending stream.
  const std::string rtcp_cname() {
    if (send_streams_.empty())
      return "";
    return send_streams_[0].cname;
  }
  const RtcpParameters& send_rtcp_parameters() { return send_rtcp_parameters_; }
  const RtcpParameters& recv_rtcp_parameters() { return recv_rtcp_parameters_; }

  bool ready_to_send() const { return ready_to_send_; }

  int transport_overhead_per_packet() const {
    return transport_overhead_per_packet_;
  }

  rtc::NetworkRoute last_network_route() const { return last_network_route_; }
  int num_network_route_changes() const { return num_network_route_changes_; }
  void set_num_network_route_changes(int changes) {
    num_network_route_changes_ = changes;
  }

 protected:
  bool MuteStream(uint32_t ssrc, bool mute) {
    if (!HasSendStream(ssrc) && ssrc != 0) {
      return false;
    }
    if (mute) {
      muted_streams_.insert(ssrc);
    } else {
      muted_streams_.erase(ssrc);
    }
    return true;
  }
  bool set_sending(bool send) {
    sending_ = send;
    return true;
  }
  void set_playout(bool playout) { playout_ = playout; }
  bool SetRecvRtpHeaderExtensions(const std::vector<RtpExtension>& extensions) {
    recv_extensions_ = extensions;
    return true;
  }
  bool SetSendRtpHeaderExtensions(const std::vector<RtpExtension>& extensions) {
    send_extensions_ = extensions;
    return true;
  }
  void set_send_rtcp_parameters(const RtcpParameters& params) {
    send_rtcp_parameters_ = params;
  }
  void set_recv_rtcp_parameters(const RtcpParameters& params) {
    recv_rtcp_parameters_ = params;
  }
  virtual void OnPacketReceived(rtc::CopyOnWriteBuffer* packet,
                                const rtc::PacketTime& packet_time) {
    rtp_packets_.push_back(std::string(packet->data<char>(), packet->size()));
  }
  virtual void OnRtcpReceived(rtc::CopyOnWriteBuffer* packet,
                              const rtc::PacketTime& packet_time) {
    rtcp_packets_.push_back(std::string(packet->data<char>(), packet->size()));
  }
  virtual void OnReadyToSend(bool ready) { ready_to_send_ = ready; }

  virtual void OnNetworkRouteChanged(const std::string& transport_name,
                                     const rtc::NetworkRoute& network_route) {
    last_network_route_ = network_route;
    ++num_network_route_changes_;
    transport_overhead_per_packet_ = network_route.packet_overhead;
  }
  bool fail_set_send_codecs() const { return fail_set_send_codecs_; }
  bool fail_set_recv_codecs() const { return fail_set_recv_codecs_; }

 private:
  bool sending_;
  bool playout_;
  std::vector<RtpExtension> recv_extensions_;
  std::vector<RtpExtension> send_extensions_;
  std::list<std::string> rtp_packets_;
  std::list<std::string> rtcp_packets_;
  std::vector<StreamParams> send_streams_;
  std::vector<StreamParams> receive_streams_;
  RtcpParameters send_rtcp_parameters_;
  RtcpParameters recv_rtcp_parameters_;
  std::set<uint32_t> muted_streams_;
  std::map<uint32_t, webrtc::RtpParameters> rtp_send_parameters_;
  std::map<uint32_t, webrtc::RtpParameters> rtp_receive_parameters_;
  bool fail_set_send_codecs_;
  bool fail_set_recv_codecs_;
  uint32_t send_ssrc_;
  std::string rtcp_cname_;
  bool ready_to_send_;
  int transport_overhead_per_packet_;
  rtc::NetworkRoute last_network_route_;
  int num_network_route_changes_;
};

class FakeVoiceMediaChannel : public RtpHelper<VoiceMediaChannel> {
 public:
  struct DtmfInfo {
    DtmfInfo(uint32_t ssrc, int event_code, int duration);
    uint32_t ssrc;
    int event_code;
    int duration;
  };
  explicit FakeVoiceMediaChannel(FakeVoiceEngine* engine,
                                 const AudioOptions& options);
  ~FakeVoiceMediaChannel();
  const std::vector<AudioCodec>& recv_codecs() const;
  const std::vector<AudioCodec>& send_codecs() const;
  const std::vector<AudioCodec>& codecs() const;
  const std::vector<DtmfInfo>& dtmf_info_queue() const;
  const AudioOptions& options() const;
  int max_bps() const;
  bool SetSendParameters(const AudioSendParameters& params) override;

  bool SetRecvParameters(const AudioRecvParameters& params) override;

  void SetPlayout(bool playout) override;
  void SetSend(bool send) override;
  bool SetAudioSend(uint32_t ssrc,
                    bool enable,
                    const AudioOptions* options,
                    AudioSource* source) override;

  bool HasSource(uint32_t ssrc) const;

  bool AddRecvStream(const StreamParams& sp) override;
  bool RemoveRecvStream(uint32_t ssrc) override;

  bool CanInsertDtmf() override;
  bool InsertDtmf(uint32_t ssrc, int event_code, int duration) override;

  bool SetOutputVolume(uint32_t ssrc, double volume) override;
  bool GetOutputVolume(uint32_t ssrc, double* volume);

  bool GetStats(VoiceMediaInfo* info) override;

  void SetRawAudioSink(
      uint32_t ssrc,
      std::unique_ptr<webrtc::AudioSinkInterface> sink) override;

  std::vector<webrtc::RtpSource> GetSources(uint32_t ssrc) const override;

 private:
  class VoiceChannelAudioSink : public AudioSource::Sink {
   public:
    explicit VoiceChannelAudioSink(AudioSource* source);
    ~VoiceChannelAudioSink() override;
    void OnData(const void* audio_data,
                int bits_per_sample,
                int sample_rate,
                size_t number_of_channels,
                size_t number_of_frames) override;
    void OnClose() override;
    AudioSource* source() const;

   private:
    AudioSource* source_;
  };

  bool SetRecvCodecs(const std::vector<AudioCodec>& codecs);
  bool SetSendCodecs(const std::vector<AudioCodec>& codecs);
  bool SetMaxSendBandwidth(int bps);
  bool SetOptions(const AudioOptions& options);
  bool SetLocalSource(uint32_t ssrc, AudioSource* source);

  FakeVoiceEngine* engine_;
  std::vector<AudioCodec> recv_codecs_;
  std::vector<AudioCodec> send_codecs_;
  std::map<uint32_t, double> output_scalings_;
  std::vector<DtmfInfo> dtmf_info_queue_;
  AudioOptions options_;
  std::map<uint32_t, std::unique_ptr<VoiceChannelAudioSink>> local_sinks_;
  std::unique_ptr<webrtc::AudioSinkInterface> sink_;
  int max_bps_;
};

// A helper function to compare the FakeVoiceMediaChannel::DtmfInfo.
bool CompareDtmfInfo(const FakeVoiceMediaChannel::DtmfInfo& info,
                     uint32_t ssrc,
                     int event_code,
                     int duration);

class FakeVideoMediaChannel : public RtpHelper<VideoMediaChannel> {
 public:
  FakeVideoMediaChannel(FakeVideoEngine* engine, const VideoOptions& options);

  ~FakeVideoMediaChannel();

  const std::vector<VideoCodec>& recv_codecs() const;
  const std::vector<VideoCodec>& send_codecs() const;
  const std::vector<VideoCodec>& codecs() const;
  bool rendering() const;
  const VideoOptions& options() const;
  const std::map<uint32_t, rtc::VideoSinkInterface<webrtc::VideoFrame>*>&
  sinks() const;
  int max_bps() const;
  bool SetSendParameters(const VideoSendParameters& params) override;
  bool SetRecvParameters(const VideoRecvParameters& params) override;
  bool AddSendStream(const StreamParams& sp) override;
  bool RemoveSendStream(uint32_t ssrc) override;

  bool GetSendCodec(VideoCodec* send_codec) override;
  bool SetSink(uint32_t ssrc,
               rtc::VideoSinkInterface<webrtc::VideoFrame>* sink) override;
  bool HasSink(uint32_t ssrc) const;

  bool SetSend(bool send) override;
  bool SetVideoSend(
      uint32_t ssrc,
      const VideoOptions* options,
      rtc::VideoSourceInterface<webrtc::VideoFrame>* source) override;

  bool HasSource(uint32_t ssrc) const;
  bool AddRecvStream(const StreamParams& sp) override;
  bool RemoveRecvStream(uint32_t ssrc) override;

  void FillBitrateInfo(BandwidthEstimationInfo* bwe_info) override;
  bool GetStats(VideoMediaInfo* info) override;

  std::vector<webrtc::RtpSource> GetSources(uint32_t ssrc) const override;

 private:
  bool SetRecvCodecs(const std::vector<VideoCodec>& codecs);
  bool SetSendCodecs(const std::vector<VideoCodec>& codecs);
  bool SetOptions(const VideoOptions& options);
  bool SetMaxSendBandwidth(int bps);

  FakeVideoEngine* engine_;
  std::vector<VideoCodec> recv_codecs_;
  std::vector<VideoCodec> send_codecs_;
  std::map<uint32_t, rtc::VideoSinkInterface<webrtc::VideoFrame>*> sinks_;
  std::map<uint32_t, rtc::VideoSourceInterface<webrtc::VideoFrame>*> sources_;
  VideoOptions options_;
  int max_bps_;
};

// Dummy option class, needed for the DataTraits abstraction in
// channel_unittest.c.
class DataOptions {};

class FakeDataMediaChannel : public RtpHelper<DataMediaChannel> {
 public:
  explicit FakeDataMediaChannel(void* unused, const DataOptions& options);
  ~FakeDataMediaChannel();
  const std::vector<DataCodec>& recv_codecs() const;
  const std::vector<DataCodec>& send_codecs() const;
  const std::vector<DataCodec>& codecs() const;
  int max_bps() const;

  bool SetSendParameters(const DataSendParameters& params) override;
  bool SetRecvParameters(const DataRecvParameters& params) override;
  bool SetSend(bool send) override;
  bool SetReceive(bool receive) override;
  bool AddRecvStream(const StreamParams& sp) override;
  bool RemoveRecvStream(uint32_t ssrc) override;

  bool SendData(const SendDataParams& params,
                const rtc::CopyOnWriteBuffer& payload,
                SendDataResult* result) override;

  SendDataParams last_sent_data_params();
  std::string last_sent_data();
  bool is_send_blocked();
  void set_send_blocked(bool blocked);

 private:
  bool SetRecvCodecs(const std::vector<DataCodec>& codecs);
  bool SetSendCodecs(const std::vector<DataCodec>& codecs);
  bool SetMaxSendBandwidth(int bps);

  std::vector<DataCodec> recv_codecs_;
  std::vector<DataCodec> send_codecs_;
  SendDataParams last_sent_data_params_;
  std::string last_sent_data_;
  bool send_blocked_;
  int max_bps_;
};

class FakeVoiceEngine {
 public:
  FakeVoiceEngine();
  RtpCapabilities GetCapabilities() const;
  void Init();
  rtc::scoped_refptr<webrtc::AudioState> GetAudioState() const;

  VoiceMediaChannel* CreateChannel(webrtc::Call* call,
                                   const MediaConfig& config,
                                   const AudioOptions& options,
                                   const webrtc::CryptoOptions& crypto_options);
  FakeVoiceMediaChannel* GetChannel(size_t index);
  void UnregisterChannel(VoiceMediaChannel* channel);

  // TODO(ossu): For proper testing, These should either individually settable
  //             or the voice engine should reference mockable factories.
  const std::vector<AudioCodec>& send_codecs() const;
  const std::vector<AudioCodec>& recv_codecs() const;
  void SetCodecs(const std::vector<AudioCodec>& codecs);
  int GetInputLevel();
  bool StartAecDump(rtc::PlatformFile file, int64_t max_size_bytes);
  void StopAecDump();
  bool StartRtcEventLog(rtc::PlatformFile file, int64_t max_size_bytes);
  void StopRtcEventLog();

 private:
  std::vector<FakeVoiceMediaChannel*> channels_;
  std::vector<AudioCodec> codecs_;
  bool fail_create_channel_;

  friend class FakeMediaEngine;
};

class FakeVideoEngine {
 public:
  FakeVideoEngine();
  RtpCapabilities GetCapabilities() const;
  bool SetOptions(const VideoOptions& options);
  VideoMediaChannel* CreateChannel(webrtc::Call* call,
                                   const MediaConfig& config,
                                   const VideoOptions& options,
                                   const webrtc::CryptoOptions& crypto_options);
  FakeVideoMediaChannel* GetChannel(size_t index);
  void UnregisterChannel(VideoMediaChannel* channel);
  std::vector<VideoCodec> codecs() const;
  void SetCodecs(const std::vector<VideoCodec> codecs);
  bool SetCapture(bool capture);

 private:
  std::vector<FakeVideoMediaChannel*> channels_;
  std::vector<VideoCodec> codecs_;
  bool capture_;
  VideoOptions options_;
  bool fail_create_channel_;

  friend class FakeMediaEngine;
};

class FakeMediaEngine
    : public CompositeMediaEngine<FakeVoiceEngine, FakeVideoEngine> {
 public:
  FakeMediaEngine();

  ~FakeMediaEngine() override;

  void SetAudioCodecs(const std::vector<AudioCodec>& codecs);
  void SetVideoCodecs(const std::vector<VideoCodec>& codecs);

  FakeVoiceMediaChannel* GetVoiceChannel(size_t index);
  FakeVideoMediaChannel* GetVideoChannel(size_t index);

  void set_fail_create_channel(bool fail);

 private:
  FakeVoiceEngine* const voice_;
  FakeVideoEngine* const video_;
};

// Have to come afterwards due to declaration order

class FakeDataEngine : public DataEngineInterface {
 public:
  DataMediaChannel* CreateChannel(const MediaConfig& config) override;

  FakeDataMediaChannel* GetChannel(size_t index);

  void UnregisterChannel(DataMediaChannel* channel);

  void SetDataCodecs(const std::vector<DataCodec>& data_codecs);

  const std::vector<DataCodec>& data_codecs() override;

 private:
  std::vector<FakeDataMediaChannel*> channels_;
  std::vector<DataCodec> data_codecs_;
};

}  // namespace cricket

#endif  // MEDIA_BASE_FAKEMEDIAENGINE_H_