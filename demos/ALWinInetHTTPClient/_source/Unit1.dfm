object Form1: TForm1
  Left = 377
  Top = 296
  Caption = 'TALWinInetHttpClient test'
  ClientHeight = 608
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MainStatusBar: TStatusBar
    Left = 0
    Top = 589
    Width = 796
    Height = 19
    Color = 15525605
    Panels = <
      item
        Width = 300
      end
      item
        Width = 250
      end
      item
        Width = 50
      end>
  end
  object PageControl1: TcxPageControl
    Left = 0
    Top = 0
    Width = 796
    Height = 589
    Hint = ''
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = TabSheet1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 584
    ClientRectLeft = 5
    ClientRectRight = 791
    ClientRectTop = 27
    object TabSheet1: TcxTabSheet
      Caption = 'Main'
      object GroupBox9: TcxGroupBox
        Left = 0
        Top = 10
        Hint = ''
        Align = alTop
        Caption = 'REQUEST'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        DesignSize = (
          786
          187)
        Height = 193
        Width = 786
        object Label4: TcxLabel
          Left = 8
          Top = 62
          Hint = ''
          Caption = 'Post Data Strings'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -11
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = [fsBold]
          Style.IsFontAssigned = True
          Transparent = True
        end
        object Label6: TcxLabel
          Left = 8
          Top = 78
          Hint = ''
          Caption = 'Format "name=value" if not URL Encode Post Data checked'
          ParentFont = False
          Transparent = True
        end
        object Label7: TcxLabel
          Left = 392
          Top = 78
          Hint = ''
          Caption = 'Format "Name=FileName"'
          ParentFont = False
          Transparent = True
        end
        object Label5: TcxLabel
          Left = 392
          Top = 62
          Hint = ''
          Caption = 'Post Data Files'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -11
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = [fsBold]
          Style.IsFontAssigned = True
          Transparent = True
        end
        object Label1: TcxLabel
          Left = 8
          Top = 27
          Hint = ''
          Caption = 'URL'
          ParentFont = False
          Transparent = True
        end
        object editURL: TcxTextEdit
          Left = 40
          Top = 24
          Hint = ''
          ParentFont = False
          TabOrder = 0
          Text = 'http://www.wikipedia.org'
          Width = 305
        end
        object MemoPostDataStrings: TcxMemo
          Left = 8
          Top = 94
          Hint = ''
          ParentFont = False
          Properties.ScrollBars = ssVertical
          Properties.WordWrap = False
          TabOrder = 1
          Height = 73
          Width = 375
        end
        object MemoPostDataFiles: TcxMemo
          Left = 392
          Top = 94
          Hint = ''
          Anchors = [akLeft, akTop, akRight, akBottom]
          ParentFont = False
          Properties.ScrollBars = ssVertical
          Properties.WordWrap = False
          TabOrder = 2
          Height = 73
          Width = 384
        end
        object ButtonPost: TcxButton
          Left = 407
          Top = 21
          Width = 50
          Height = 25
          Caption = 'Post'
          TabOrder = 3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = ButtonPostClick
        end
        object ButtonGet: TcxButton
          Left = 351
          Top = 21
          Width = 50
          Height = 25
          Caption = 'Get'
          TabOrder = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = ButtonGetClick
        end
        object CheckBoxHttpEncodePostData: TcxCheckBox
          Left = 11
          Top = 171
          Hint = ''
          Caption = 'HTTP Encode Post Data'
          ParentFont = False
          TabOrder = 5
          Transparent = True
          Width = 150
        end
        object ButtonHead: TcxButton
          Left = 462
          Top = 21
          Width = 50
          Height = 25
          Caption = 'Head'
          TabOrder = 6
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = ButtonHeadClick
        end
        object CheckBoxUrlEncodePostData: TcxCheckBox
          Left = 169
          Top = 171
          Hint = ''
          Caption = 'URL Encode Post Data'
          ParentFont = False
          TabOrder = 7
          Transparent = True
          Width = 138
        end
        object ButtonTrace: TcxButton
          Left = 518
          Top = 21
          Width = 50
          Height = 25
          Caption = 'Trace'
          TabOrder = 8
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = ButtonTraceClick
        end
      end
      object GroupBox10: TcxGroupBox
        Left = 0
        Top = 223
        Hint = ''
        Align = alClient
        Caption = 'RESPONSE'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 1
        Height = 334
        Width = 786
        object Panel5: TPanel
          Left = 3
          Top = 15
          Width = 267
          Height = 310
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            267
            310)
          object Label2: TcxLabel
            Left = 5
            Top = 6
            Hint = ''
            Caption = 'Header:'
            ParentFont = False
            Transparent = True
          end
          object MemoResponseRawHeader: TcxMemo
            Left = 5
            Top = 24
            Hint = ''
            Anchors = [akLeft, akTop, akRight, akBottom]
            ParentFont = False
            Properties.ScrollBars = ssBoth
            Properties.WordWrap = False
            TabOrder = 1
            Height = 281
            Width = 260
          end
        end
        object Panel6: TPanel
          Left = 277
          Top = 15
          Width = 506
          Height = 310
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel5'
          TabOrder = 1
          DesignSize = (
            506
            310)
          object Label3: TcxLabel
            Left = 2
            Top = 6
            Hint = ''
            Caption = 'Content:'
            ParentFont = False
            Transparent = True
          end
          object MemoContentBody: TcxMemo
            Left = 2
            Top = 24
            Hint = ''
            Anchors = [akLeft, akTop, akRight, akBottom]
            ParentFont = False
            Properties.ScrollBars = ssBoth
            Properties.WordWrap = False
            TabOrder = 1
            Height = 281
            Width = 486
          end
        end
        object cxSplitter1: TcxSplitter
          Left = 270
          Top = 15
          Width = 7
          Height = 310
          Hint = ''
          Control = Panel5
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 786
        Height = 10
        Align = alTop
        BevelOuter = bvNone
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
      end
      object Panel4: TPanel
        Left = 0
        Top = 203
        Width = 786
        Height = 20
        Align = alTop
        BevelOuter = bvNone
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 3
      end
    end
    object TabSheet2: TcxTabSheet
      Caption = 'Configuration'
      ImageIndex = 1
      object GroupBox3: TcxGroupBox
        Left = 7
        Top = 11
        Hint = ''
        Caption = 'Authentication'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Height = 70
        Width = 289
        object Label18: TcxLabel
          Left = 16
          Top = 21
          Hint = ''
          Caption = 'UserName'
          ParentFont = False
          Transparent = True
        end
        object Label19: TcxLabel
          Left = 20
          Top = 46
          Hint = ''
          Caption = 'Password'
          ParentFont = False
          Transparent = True
        end
        object EditUserName: TcxTextEdit
          Left = 73
          Top = 18
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 0
          OnClick = OnCfgEditCHange
          Width = 200
        end
        object EditPassword: TcxTextEdit
          Left = 73
          Top = 42
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 1
          OnClick = OnCfgEditCHange
          Width = 200
        end
      end
      object GroupBox4: TcxGroupBox
        Left = 7
        Top = 91
        Hint = ''
        Caption = 'Timeout'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 1
        Height = 94
        Width = 289
        object Label14: TcxLabel
          Left = 41
          Top = 45
          Hint = ''
          Caption = 'Send'
          ParentFont = False
          Transparent = True
        end
        object Label17: TcxLabel
          Left = 26
          Top = 21
          Hint = ''
          Caption = 'Connect'
          ParentFont = False
          Transparent = True
        end
        object Label20: TcxLabel
          Left = 26
          Top = 69
          Hint = ''
          Caption = 'Receive'
          ParentFont = False
          Transparent = True
        end
        object EditSendTimeout: TcxTextEdit
          Left = 73
          Top = 42
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 0
          Text = '0'
          OnClick = OnCfgEditCHange
          Width = 200
        end
        object EditReceiveTimeout: TcxTextEdit
          Left = 73
          Top = 66
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 1
          Text = '0'
          OnClick = OnCfgEditCHange
          Width = 200
        end
        object EditConnectTimeout: TcxTextEdit
          Left = 73
          Top = 18
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 2
          Text = '0'
          OnClick = OnCfgEditCHange
          Width = 200
        end
      end
      object GroupBox6: TcxGroupBox
        Left = 7
        Top = 195
        Hint = ''
        Caption = 'Protocole version'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 2
        Height = 54
        Width = 289
        object RadioButtonProtocolVersion1_0: TcxRadioButton
          Left = 32
          Top = 21
          Width = 73
          Height = 17
          Caption = 'HTTP/1.0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Transparent = True
        end
        object RadioButtonProtocolVersion1_1: TcxRadioButton
          Left = 128
          Top = 21
          Width = 81
          Height = 17
          Caption = 'HTTP/1.1'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TabStop = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Transparent = True
        end
      end
      object GroupBox7: TcxGroupBox
        Left = 304
        Top = 11
        Hint = ''
        Caption = 'Internet options'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 3
        Height = 534
        Width = 161
        object CheckBoxInternetOption_From_Cache: TcxCheckBox
          Left = 8
          Top = 24
          Hint = ''
          Caption = 'From_Cache'
          ParentFont = False
          TabOrder = 0
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Offline: TcxCheckBox
          Left = 8
          Top = 48
          Hint = ''
          Caption = 'Offline'
          ParentFont = False
          TabOrder = 1
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Keep_connection: TcxCheckBox
          Left = 8
          Top = 216
          Hint = ''
          Caption = 'Keep_connection'
          ParentFont = False
          State = cbsChecked
          TabOrder = 2
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_No_auto_redirect: TcxCheckBox
          Left = 8
          Top = 288
          Hint = ''
          Caption = 'No_auto_redirect'
          ParentFont = False
          TabOrder = 3
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Ignore_redirect_to_https: TcxCheckBox
          Left = 8
          Top = 192
          Hint = ''
          Caption = 'Ignore_redirect_to_https'
          ParentFont = False
          TabOrder = 4
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_No_auth: TcxCheckBox
          Left = 8
          Top = 264
          Hint = ''
          Caption = 'No_auth'
          ParentFont = False
          TabOrder = 5
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Ignore_cert_date_invalid: TcxCheckBox
          Left = 8
          Top = 144
          Hint = ''
          Caption = 'Ignore_cert_date_invalid'
          ParentFont = False
          TabOrder = 6
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Need_file: TcxCheckBox
          Left = 8
          Top = 240
          Hint = ''
          Caption = 'Need_file'
          ParentFont = False
          TabOrder = 7
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Ignore_redirect_to_http: TcxCheckBox
          Left = 8
          Top = 168
          Hint = ''
          Caption = 'Ignore_redirect_to_http'
          ParentFont = False
          TabOrder = 8
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Hyperlink: TcxCheckBox
          Left = 8
          Top = 96
          Hint = ''
          Caption = 'Hyperlink'
          ParentFont = False
          TabOrder = 9
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Ignore_cert_cn_invalid: TcxCheckBox
          Left = 8
          Top = 120
          Hint = ''
          Caption = 'Ignore_cert_cn_invalid'
          ParentFont = False
          TabOrder = 10
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Cache_if_net_fail: TcxCheckBox
          Left = 8
          Top = 72
          Hint = ''
          Caption = 'Cache_if_net_fail'
          ParentFont = False
          TabOrder = 11
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_No_cache_write: TcxCheckBox
          Left = 8
          Top = 312
          Hint = ''
          Caption = 'No_cache_write'
          ParentFont = False
          TabOrder = 12
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Resynchronize: TcxCheckBox
          Left = 8
          Top = 432
          Hint = ''
          Caption = 'Resynchronize'
          ParentFont = False
          TabOrder = 13
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_No_cookies: TcxCheckBox
          Left = 8
          Top = 336
          Hint = ''
          Caption = 'No_cookies'
          ParentFont = False
          TabOrder = 14
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Pragma_nocache: TcxCheckBox
          Left = 8
          Top = 384
          Hint = ''
          Caption = 'Pragma_nocache'
          ParentFont = False
          TabOrder = 15
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Reload: TcxCheckBox
          Left = 8
          Top = 408
          Hint = ''
          Caption = 'Reload'
          ParentFont = False
          TabOrder = 16
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_No_ui: TcxCheckBox
          Left = 8
          Top = 360
          Hint = ''
          Caption = 'No_ui'
          ParentFont = False
          TabOrder = 17
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
        object CheckBoxInternetOption_Secure: TcxCheckBox
          Left = 8
          Top = 456
          Hint = ''
          Caption = 'Secure'
          ParentFont = False
          TabOrder = 18
          Transparent = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Width = 150
        end
      end
      object GroupBox2: TcxGroupBox
        Left = 8
        Top = 475
        Hint = ''
        Caption = 'Access Type'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 4
        Height = 70
        Width = 289
        object RadioButtonAccessType_Direct: TcxRadioButton
          Left = 16
          Top = 48
          Width = 65
          Height = 17
          Caption = 'Direct'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Transparent = True
        end
        object RadioButtonAccessType_Preconfig: TcxRadioButton
          Left = 16
          Top = 24
          Width = 73
          Height = 17
          Caption = 'Preconfig'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TabStop = True
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Transparent = True
        end
        object RadioButtonAccessType_Preconfig_with_no_autoproxy: TcxRadioButton
          Left = 104
          Top = 24
          Width = 163
          Height = 17
          Caption = 'Preconfig_with_no_autoproxy'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Transparent = True
        end
        object RadioButtonAccessType_Proxy: TcxRadioButton
          Left = 104
          Top = 48
          Width = 113
          Height = 17
          Caption = 'Proxy'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = OnCfgEditCHange
          OnEnter = OnCfgEditCHange
          OnKeyPress = OnCfgEditKeyPress
          Transparent = True
        end
      end
      object GroupBox1: TcxGroupBox
        Left = 8
        Top = 323
        Hint = ''
        Caption = 'Proxy'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 5
        Height = 145
        Width = 289
        object Label15: TcxLabel
          Left = 47
          Top = 45
          Hint = ''
          Caption = 'Port'
          ParentFont = False
          Transparent = True
        end
        object Label12: TcxLabel
          Left = 35
          Top = 21
          Hint = ''
          Caption = 'Server'
          ParentFont = False
          Transparent = True
        end
        object Label11: TcxLabel
          Left = 16
          Top = 69
          Hint = ''
          Caption = 'UserName'
          ParentFont = False
          Transparent = True
        end
        object Label16: TcxLabel
          Left = 20
          Top = 94
          Hint = ''
          Caption = 'Password'
          ParentFont = False
          Transparent = True
        end
        object Label13: TcxLabel
          Left = 32
          Top = 117
          Hint = ''
          Caption = 'Bypass'
          ParentFont = False
          Transparent = True
        end
        object EdProxyPort: TcxTextEdit
          Left = 73
          Top = 42
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 0
          Text = '80'
          OnClick = OnCfgEditCHange
          Width = 200
        end
        object EdProxyUserName: TcxTextEdit
          Left = 73
          Top = 66
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 1
          OnClick = OnCfgEditCHange
          Width = 200
        end
        object EdProxyServer: TcxTextEdit
          Left = 73
          Top = 18
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 2
          OnClick = OnCfgEditCHange
          Width = 200
        end
        object EdProxyPassword: TcxTextEdit
          Left = 73
          Top = 90
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 3
          OnClick = OnCfgEditCHange
          Width = 200
        end
        object EdProxyBypass: TcxTextEdit
          Left = 73
          Top = 114
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 4
          Text = '<local>'
          OnClick = OnCfgEditCHange
          Width = 200
        end
      end
      object GroupBox5: TcxGroupBox
        Left = 8
        Top = 259
        Hint = ''
        Caption = 'Buffer Size'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 6
        Height = 54
        Width = 289
        object Label24: TcxLabel
          Left = 27
          Top = 21
          Hint = ''
          Caption = 'Upload'
          ParentFont = False
          Transparent = True
        end
        object EditBufferUploadSize: TcxTextEdit
          Left = 73
          Top = 18
          Hint = ''
          ParentFont = False
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 0
          Text = '32768'
          OnClick = OnCfgEditCHange
          Width = 200
        end
      end
      object GroupBox8: TcxGroupBox
        Left = 472
        Top = 11
        Hint = ''
        Caption = 'Request Raw Header '
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 7
        Height = 534
        Width = 313
        object Label8: TcxLabel
          Left = 9
          Top = 22
          Hint = ''
          Caption = 'Format "Name: values" on each lines'
          ParentFont = False
          Transparent = True
        end
        object MemoRequestRawHeader: TcxMemo
          Left = 9
          Top = 38
          Hint = ''
          ParentFont = False
          Properties.ScrollBars = ssVertical
          Properties.OnChange = OnCfgEditCHange
          TabOrder = 0
          OnClick = OnCfgEditCHange
          Height = 487
          Width = 294
        end
      end
    end
  end
  object dxSkinController1: TdxSkinController
    NativeStyle = False
    SkinName = 'Foggy'
    Left = 360
    Top = 224
  end
end