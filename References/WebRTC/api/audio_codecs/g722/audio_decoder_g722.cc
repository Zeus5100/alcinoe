/*
 *  Copyright (c) 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "api/audio_codecs/g722/audio_decoder_g722.h"

#include <memory>
#include <vector>

#include "absl/memory/memory.h"
#include "absl/strings/match.h"
#include "modules/audio_coding/codecs/g722/audio_decoder_g722.h"
#include "rtc_base/numerics/safe_conversions.h"

namespace webrtc {

absl::optional<AudioDecoderG722::Config> AudioDecoderG722::SdpToConfig(
    const SdpAudioFormat& format) {
  return absl::EqualsIgnoreCase(format.name, "G722") &&
                 format.clockrate_hz == 8000 &&
                 (format.num_channels == 1 || format.num_channels == 2)
             ? absl::optional<Config>(
                   Config{rtc::dchecked_cast<int>(format.num_channels)})
             : absl::nullopt;
}

void AudioDecoderG722::AppendSupportedDecoders(
    std::vector<AudioCodecSpec>* specs) {
  specs->push_back({{"G722", 8000, 1}, {16000, 1, 64000}});
}

std::unique_ptr<AudioDecoder> AudioDecoderG722::MakeAudioDecoder(
    Config config,
    absl::optional<AudioCodecPairId> /*codec_pair_id*/) {
  switch (config.num_channels) {
    case 1:
      return absl::make_unique<AudioDecoderG722Impl>();
    case 2:
      return absl::make_unique<AudioDecoderG722StereoImpl>();
    default:
      return nullptr;
  }
}

}  // namespace webrtc
