unit Alcinoe.FMX.Edit;

interface

{$I Alcinoe.inc}

uses
  System.Types,
  system.Classes,
  System.UITypes,
  {$IF defined(android)}
  System.Messaging,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNIBridge,
  Androidapi.JNI.Widget,
  Androidapi.JNI.JavaTypes,
  Alcinoe.AndroidApi.Common,
  Alcinoe.FMX.NativeView.Android,
  {$ELSEIF defined(IOS)}
  System.TypInfo,
  iOSapi.Foundation,
  iOSapi.UIKit,
  Macapi.ObjectiveC,
  Macapi.ObjCRuntime,
  Alcinoe.FMX.NativeView.iOS,
  {$ELSEIF defined(ALMacOS)}
  System.TypInfo,
  Macapi.Foundation,
  Macapi.AppKit,
  Macapi.ObjectiveC,
  Macapi.ObjCRuntime,
  Macapi.CocoaTypes,
  Alcinoe.FMX.NativeView.Mac,
  {$ELSEIF defined(MSWINDOWS)}
  Winapi.Messages,
  Winapi.Windows,
  FMX.Controls.Win,
  FMX.Helpers.Win,
  Alcinoe.FMX.NativeView.Win,
  {$ENDIF}
  FMX.types,
  Fmx.controls,
  fmx.Graphics,
  Alcinoe.FMX.Controls,
  Alcinoe.FMX.Ani,
  Alcinoe.FMX.Common,
  Alcinoe.FMX.Objects,
  Alcinoe.FMX.Graphics;

Type

  {**********************************************}
  TALEditTextSettings = class(TALBaseTextSettings)
  published
    property Font;
    property HorzAlign;
  end;

  {***************************}
  TALAutoCapitalizationType = (
    acNone, // Specifies that there is no automatic text capitalization.
    acWords, // Specifies automatic capitalization of the first letter of each word.
    acSentences, // Specifies automatic capitalization of the first letter of each sentence.
    acAllCharacters); // Specifies automatic capitalization of all characters, such as for entry of two-character state abbreviations for the United States.

  {************************************}
  TALBaseEditControl = class(TALControl)
  strict private
    fOnChangeTracking: TNotifyEvent;
    fOnReturnKey: TNotifyEvent;
    FTextSettings: TALEditTextSettings;
  protected
    {$IF defined(android)}
    FNativeView: TALAndroidNativeView;
    Function CreateNativeView: TALAndroidNativeView; virtual; abstract;
    function GetNativeView: TALAndroidNativeView; virtual;
    {$ELSEIF defined(IOS)}
    FNativeView: TALIosNativeView;
    Function CreateNativeView: TALIosNativeView; virtual; abstract;
    function GetNativeView: TALIosNativeView; virtual;
    {$ELSEIF defined(ALMacOS)}
    FNativeView: TALMacNativeView;
    Function CreateNativeView: TALMacNativeView; virtual; abstract;
    function GetNativeView: TALMacNativeView; virtual;
    {$ELSEIF defined(MSWindows)}
    FNativeView: TALWinNativeView;
    Function CreateNativeView: TALWinNativeView; virtual; abstract;
    function GetNativeView: TALWinNativeView; virtual;
    {$ENDIF}
    function GetKeyboardType: TVirtualKeyboardType; virtual; abstract;
    procedure setKeyboardType(const Value: TVirtualKeyboardType); virtual; abstract;
    function GetAutoCapitalizationType: TALAutoCapitalizationType; virtual; abstract;
    procedure setAutoCapitalizationType(const Value: TALAutoCapitalizationType); virtual; abstract;
    function GetPassword: Boolean; virtual; abstract;
    procedure setPassword(const Value: Boolean); virtual; abstract;
    function GetCheckSpelling: Boolean; virtual; abstract;
    procedure setCheckSpelling(const Value: Boolean); virtual; abstract;
    function GetReturnKeyType: TReturnKeyType; virtual; abstract;
    procedure setReturnKeyType(const Value: TReturnKeyType); virtual; abstract;
    function GetPromptText: String; virtual; abstract;
    procedure setPromptText(const Value: String); virtual; abstract;
    function GetPromptTextColor: TAlphaColor; virtual; abstract;
    procedure setPromptTextColor(const Value: TAlphaColor); virtual; abstract;
    function GetTintColor: TAlphaColor; virtual; abstract;
    procedure setTintColor(const Value: TAlphaColor); virtual; abstract;
    function GetFillColor: TAlphaColor; virtual; abstract;
    procedure SetFillColor(const Value: TAlphaColor); virtual; abstract;
    procedure SetTextSettings(const Value: TALEditTextSettings); virtual;
    procedure TextSettingsChanged(Sender: TObject); virtual; abstract;
    function getText: String; virtual; abstract;
    procedure SetText(const Value: String); virtual; abstract;
    function GetMaxLength: integer; virtual; abstract;
    procedure SetMaxLength(const Value: integer); virtual; abstract;
    procedure DoChangeTracking; virtual;
    procedure DoReturnKey; virtual;
    procedure AncestorVisibleChanged(const Visible: Boolean); override;
    procedure AncestorParentChanged; override;
    procedure ParentChanged; override;
    procedure DoAbsoluteChanged; override;
    procedure DoRootChanged; override;
    procedure Resize; override;
    procedure VisibleChanged; override;
    procedure ChangeOrder; override;
    procedure DoEndUpdate; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RecalcOpacity; override;
    procedure RecalcEnabled; override;
    function getLineCount: integer; virtual;
    function getLineHeight: Single; virtual; abstract; // It includes the line spacing
    function HasNativeView: boolean; virtual;
    Procedure AddNativeView; virtual;
    Procedure RemoveNativeView; virtual;
    {$IF defined(android)}
    property NativeView: TALAndroidNativeView read GetNativeView;
    {$ELSEIF defined(IOS)}
    property NativeView: TALIosNativeView read GetNativeView;
    {$ELSEIF defined(ALMacOS)}
    property NativeView: TALMacNativeView read GetNativeView;
    {$ELSEIF defined(MSWindows)}
    property NativeView: TALWinNativeView read GetNativeView;
    {$ENDIF}
    property OnChangeTracking: TNotifyEvent read fOnChangeTracking write fOnChangeTracking;
    property OnReturnKey: TNotifyEvent read fOnReturnKey write fOnReturnKey;
    property ReturnKeyType: TReturnKeyType read GetReturnKeyType write SetReturnKeyType;
    property KeyboardType: TVirtualKeyboardType read GetKeyboardType write SetKeyboardType;
    property AutoCapitalizationType: TALAutoCapitalizationType read GetAutoCapitalizationType write SetAutoCapitalizationType;
    property Password: Boolean read GetPassword write SetPassword;
    property PromptText: String read GetPromptText write setPromptText;
    property PromptTextColor: TAlphaColor read GetPromptTextColor write setPromptTextColor; // Null mean use the default color
    property TintColor: TalphaColor read GetTintColor write SetTintColor;
    property FillColor: TAlphaColor read GetFillColor write SetFillColor;
    property MaxLength: integer read GetMaxLength write SetMaxLength;
    property Text: String read getText write SetText;
    property TextSettings: TALEditTextSettings read FTextSettings write SetTextSettings;
    property CheckSpelling: Boolean read GetCheckSpelling write SetCheckSpelling;
  end;

{$REGION ' ANDROID'}
{$IF defined(android)}
type

  {****************************}
  TALAndroidEditControl = class;

  {**********************************************}
  TALAndroidEditText = class(TALAndroidNativeView)
  private

    type

      {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
      TALTextWatcher = class(TJavaLocal, JTextWatcher)
      private
        FEditText: TALAndroidEditText;
      public
        constructor Create(const aEditText: TALAndroidEditText);
        procedure afterTextChanged(s: JEditable); cdecl;
        procedure beforeTextChanged(s: JCharSequence; start: Integer; count: Integer; after: Integer); cdecl;
        procedure onTextChanged(s: JCharSequence; start: Integer; before: Integer; count: Integer); cdecl;
      end;

      {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
      TALEditorActionListener = class(TJavaLocal, JTextView_OnEditorActionListener)
      private
        fIsMultiLineEditText: Boolean;
        FEditText: TALAndroidEditText;
      public
        constructor Create(const aEditText: TALAndroidEditText; const aIsMultiLineEditText: Boolean = false);
        function onEditorAction(v: JTextView; actionId: Integer; event: JKeyEvent): Boolean; cdecl;
      end;

      {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
      TALKeyPreImeListener = class(TJavaLocal, JALKeyPreImeListener)
      private
        FEditText: TALAndroidEditText;
      public
        constructor Create(const aEditText: TALAndroidEditText);
        function onKeyPreIme(keyCode: Integer; event: JKeyEvent): Boolean; cdecl;
      end;

      {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
      TALTouchListener = class(TJavaLocal, JView_OnTouchListener)
      private
        FEditText: TALAndroidEditText;
      public
        constructor Create(const aEditText: TALAndroidEditText);
        function onTouch(v: JView; event: JMotionEvent): Boolean; cdecl;
      end;

  private
    fIsMultiline: boolean;
    fDefStyleAttr: String;
    fDefStyleRes: String;
    FTextWatcher: TALTextWatcher;
    FEditorActionListener: TALEditorActionListener;
    FKeyPreImeListener: TALKeyPreImeListener;
    FTouchListener: TALTouchListener;
    FEditControl: TALAndroidEditControl;
    function GetView: JALEditText;
  protected
    function CreateView: JView; override;
    procedure InitView; override;
  public
    constructor Create(const AControl: TALAndroidEditControl; Const aIsMultiline: Boolean = False; const aDefStyleAttr: String = ''; const aDefStyleRes: String = ''); reintroduce;
    destructor Destroy; override;
    property View: JALEditText read GetView;
  end;

  {***********************************************}
  TALAndroidEditControl = class(TALBaseEditControl)
  private
    FFillColor: TAlphaColor;
    fMaxLength: integer;
    fApplicationEventMessageID: integer;
    fReturnKeyType: TReturnKeyType;
    fKeyboardType: TVirtualKeyboardType;
    fAutoCapitalizationType: TALAutoCapitalizationType;
    fPassword: boolean;
    fCheckSpelling: boolean;
    FDefStyleAttr: String;
    FDefStyleRes: String;
    fIsMultiline: Boolean;
    fTintColor: TalphaColor;
    procedure ApplicationEventHandler(const Sender: TObject; const M : TMessage);
  protected
    procedure DoSetInputType(
                const aKeyboardType: TVirtualKeyboardType;
                const aAutoCapitalizationType: TALAutoCapitalizationType;
                const aPassword: Boolean;
                const aCheckSpelling: Boolean;
                const aIsMultiline: Boolean); virtual;
    procedure DoSetReturnKeyType(const aReturnKeyType: TReturnKeyType); virtual;
    Function CreateNativeView: TALAndroidNativeView; override;
    function GetNativeView: TALAndroidEditText; reintroduce; virtual;
    function GetKeyboardType: TVirtualKeyboardType; override;
    procedure setKeyboardType(const Value: TVirtualKeyboardType); override;
    function GetAutoCapitalizationType: TALAutoCapitalizationType; override;
    procedure setAutoCapitalizationType(const Value: TALAutoCapitalizationType); override;
    function GetPassword: Boolean; override;
    procedure setPassword(const Value: Boolean); override;
    function GetCheckSpelling: Boolean; override;
    procedure setCheckSpelling(const Value: Boolean); override;
    function GetReturnKeyType: TReturnKeyType; override;
    procedure setReturnKeyType(const Value: TReturnKeyType); override;
    function GetPromptText: String; override;
    procedure setPromptText(const Value: String); override;
    function GetPromptTextColor: TAlphaColor; override;
    procedure setPromptTextColor(const Value: TAlphaColor); override;
    function GetTintColor: TAlphaColor; override;
    procedure setTintColor(const Value: TAlphaColor); override;
    function GetFillColor: TAlphaColor; override;
    procedure SetFillColor(const Value: TAlphaColor); override;
    procedure TextSettingsChanged(Sender: TObject); override;
    function getText: String; override;
    procedure SetText(const Value: String); override;
    function GetMaxLength: integer; override;
    procedure SetMaxLength(const Value: integer); override;
  public
    constructor Create(const AOwner: TComponent; Const AIsMultiline: Boolean = False; const ADefStyleAttr: String = ''; const ADefStyleRes: String = ''); reintroduce; virtual;
    destructor Destroy; override;
    function getLineHeight: Single; override; // It includes the line spacing
    property NativeView: TALAndroidEditText read GetNativeView;
  end;

{$endif}
{$ENDREGION}

{$REGION ' IOS'}
{$IF defined(ios)}
type

  {************************}
  TALIosEditControl = class;

  {******************************************}
  IALIosEditTextField = interface(UITextField)
    ['{E4E67240-F15A-444F-8CE1-A3A830C023E8}']
    procedure touchesBegan(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure touchesCancelled(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure touchesEnded(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure touchesMoved(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure ControlEventEditingChanged; cdecl;
    function canBecomeFirstResponder: Boolean; cdecl;
    function becomeFirstResponder: Boolean; cdecl;
  end;

  {*******************************************}
  TALIosEditTextField = class(TALIosNativeView)
  private
    FEditControl: TALIosEditControl;
    function GetView: UITextField;
    function ExtractFirstTouchPoint(touches: NSSet): TPointF;
  protected
    function GetObjectiveCClass: PTypeInfo; override;
  public
    procedure SetEnabled(const value: Boolean); override;
  public
    constructor Create; overload; override;
    constructor Create(const AControl: TControl); overload; override;
    destructor Destroy; override;
    procedure touchesBegan(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure touchesCancelled(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure touchesEnded(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure touchesMoved(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure ControlEventEditingChanged; cdecl;
    function canBecomeFirstResponder: Boolean; cdecl;
    function becomeFirstResponder: Boolean; cdecl;
    property View: UITextField read GetView;
  end;

  {****************************************************************}
  TALIosEditTextFieldDelegate = class(TOCLocal, UITextFieldDelegate)
  private
    FEditControl: TALIosEditControl;
  public
    constructor Create(const AEditControl: TALIosEditControl);
    // Better name would be textFieldShouldChangeCharactersInRange
    function textField(textField: UITextField; shouldChangeCharactersInRange: NSRange; replacementString: NSString): Boolean; cdecl;
    procedure textFieldDidBeginEditing(textField: UITextField); cdecl;
    procedure textFieldDidEndEditing(textField: UITextField); cdecl;
    function textFieldShouldBeginEditing(textField: UITextField): Boolean; cdecl;
    function textFieldShouldClear(textField: UITextField): Boolean; cdecl;
    function textFieldShouldEndEditing(textField: UITextField): Boolean; cdecl;
    function textFieldShouldReturn(textField: UITextField): Boolean; cdecl;
  end;

  {*******************************************}
  TALIosEditControl = class(TALBaseEditControl)
  private
    FTextFieldDelegate: TALIosEditTextFieldDelegate;
    FFillColor: TAlphaColor;
    fMaxLength: integer;
    fPromptTextColor: TalphaColor;
  protected
    procedure applyPromptTextWithColor(const aStr: String; const aColor: TAlphaColor); virtual;
    Function CreateNativeView: TALIosNativeView; override;
    function GetNativeView: TALIosEditTextField; reintroduce; virtual;
    function GetKeyboardType: TVirtualKeyboardType; override;
    procedure setKeyboardType(const Value: TVirtualKeyboardType); override;
    function GetAutoCapitalizationType: TALAutoCapitalizationType; override;
    procedure setAutoCapitalizationType(const Value: TALAutoCapitalizationType); override;
    function GetPassword: Boolean; override;
    procedure setPassword(const Value: Boolean); override;
    function GetCheckSpelling: Boolean; override;
    procedure setCheckSpelling(const Value: Boolean); override;
    function GetReturnKeyType: TReturnKeyType; override;
    procedure setReturnKeyType(const Value: TReturnKeyType); override;
    function GetPromptText: String; override;
    procedure setPromptText(const Value: String); override;
    function GetPromptTextColor: TAlphaColor; override;
    procedure setPromptTextColor(const Value: TAlphaColor); override;
    function GetTintColor: TAlphaColor; override;
    procedure setTintColor(const Value: TAlphaColor); override;
    function GetFillColor: TAlphaColor; override;
    procedure SetFillColor(const Value: TAlphaColor); override;
    procedure TextSettingsChanged(Sender: TObject); override;
    function getText: String; override;
    procedure SetText(const Value: String); override;
    function GetMaxLength: integer; override;
    procedure SetMaxLength(const Value: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function getLineHeight: Single; override; // It includes the line spacing
    property NativeView: TALIosEditTextField read GetNativeView;
  end;

{$endif}
{$ENDREGION}

{$REGION ' MacOS'}
{$IF defined(ALMacOS)}
type

  {************************}
  TALMacEditControl = class;

  {******************************************}
  IALMacEditTextField = interface(NSTextField)
    ['{8FA87FC0-77FB-4451-8F92-52EE1AFDD94C}']
    function acceptsFirstResponder: Boolean; cdecl;
    function becomeFirstResponder: Boolean; cdecl;
  end;

  {*******************************************}
  TALMacEditTextField = class(TALMacNativeView)
  private
    FEditControl: TALMacEditControl;
    function GetView: NSTextField;
  protected
    function GetObjectiveCClass: PTypeInfo; override;
  public
    procedure SetEnabled(const value: Boolean); override;
  public
    constructor Create; overload; override;
    constructor Create(const AControl: TControl); overload; override;
    function acceptsFirstResponder: Boolean; cdecl;
    function becomeFirstResponder: Boolean; cdecl;
    property View: NSTextField read GetView;
  end;

  {*************************************************************************}
  TALMacEditTextFieldDelegate = class(TOCLocal, NSControlTextEditingDelegate)
  private
    FEditControl: TALMacEditControl;
  public
    constructor Create(const AEditControl: TALMacEditControl);
    procedure controlTextDidBeginEditing(obj: NSNotification); cdecl;
    procedure controlTextDidEndEditing(obj: NSNotification); cdecl;
    procedure controlTextDidChange(obj: NSNotification); cdecl;
    [MethodName('control:textShouldBeginEditing:')]
    function controlTextShouldBeginEditing(control: NSControl; textShouldBeginEditing: NSText): Boolean; cdecl;
    [MethodName('control:textShouldEndEditing:')]
    function controlTextShouldEndEditing(control: NSControl; textShouldEndEditing: NSText): Boolean; cdecl;
    [MethodName('control:textView:doCommandBySelector:')]
    function controlTextViewDoCommandBySelector(control: NSControl; textView: NSTextView; doCommandBySelector: SEL): Boolean; cdecl;
  end;

  {*******************************************}
  TALMacEditControl = class(TALBaseEditControl)
  private
    FTextFieldDelegate: TALMacEditTextFieldDelegate;
    FFillColor: TAlphaColor;
    fMaxLength: integer;
    fReturnKeyType: TReturnKeyType;
    fKeyboardType: TVirtualKeyboardType;
    fAutoCapitalizationType: TALAutoCapitalizationType;
    fPassword: boolean;
    fCheckSpelling: boolean;
    fPromptTextColor: TalphaColor;
    fTintColor: TalphaColor;
  protected
    procedure applyPromptTextWithColor(const aStr: String; const aColor: TAlphaColor); virtual;
    Function CreateNativeView: TALMacNativeView; override;
    function GetNativeView: TALMacEditTextField; reintroduce; virtual;
    function GetKeyboardType: TVirtualKeyboardType; override;
    procedure setKeyboardType(const Value: TVirtualKeyboardType); override;
    function GetAutoCapitalizationType: TALAutoCapitalizationType; override;
    procedure setAutoCapitalizationType(const Value: TALAutoCapitalizationType); override;
    function GetPassword: Boolean; override;
    procedure setPassword(const Value: Boolean); override;
    function GetCheckSpelling: Boolean; override;
    procedure setCheckSpelling(const Value: Boolean); override;
    function GetReturnKeyType: TReturnKeyType; override;
    procedure setReturnKeyType(const Value: TReturnKeyType); override;
    function GetPromptText: String; override;
    procedure setPromptText(const Value: String); override;
    function GetPromptTextColor: TAlphaColor; override;
    procedure setPromptTextColor(const Value: TAlphaColor); override;
    function GetTintColor: TAlphaColor; override;
    procedure setTintColor(const Value: TAlphaColor); override;
    function GetFillColor: TAlphaColor; override;
    procedure SetFillColor(const Value: TAlphaColor); override;
    procedure TextSettingsChanged(Sender: TObject); override;
    function getText: String; override;
    procedure SetText(const Value: String); override;
    function GetMaxLength: integer; override;
    procedure SetMaxLength(const Value: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function getLineHeight: Single; override; // It includes the line spacing
    property NativeView: TALMacEditTextField read GetNativeView;
  end;

{$endif}
{$ENDREGION}

{$REGION ' MSWINDOWS'}
{$IF defined(MSWINDOWS)}
type

  {************************}
  TALWinEditControl = class;

  {**************************************}
  TALWinEditView = class(TALWinNativeView)
  private
    FFontHandle: HFONT;
    FBackgroundBrush: HBRUSH;
    FEditControl: TALWinEditControl;
    {$IF not defined(ALDPK)}
    procedure UpdateFontHandle;
    procedure UpdateBackgroundBrush;
    {$ENDIF}
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    procedure WMTextColor(var Message: WinApi.Messages.TMessage); message CN_CTLCOLOREDIT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(const AControl: TControl); override;
    destructor Destroy; override;
    property EditControl: TALWinEditControl read FEditControl;
  end;

  {*******************************************}
  TALWinEditControl = class(TALBaseEditControl)
  private
    FFillColor: TAlphaColor;
    FPromptText: String;
    FPromptTextColor: TalphaColor;
    fReturnKeyType: TReturnKeyType;
    fKeyboardType: TVirtualKeyboardType;
    fAutoCapitalizationType: TALAutoCapitalizationType;
    fCheckSpelling: boolean;
    fTintColor: TalphaColor;
    {$IF defined(ALDPK)}
    FPassword: Boolean;
    FMaxLength: Integer;
    FText: String;
    {$ENDIF}
  protected
    Function CreateNativeView: TALWinNativeView; override;
    function GetNativeView: TALWinEditView; reintroduce; virtual;
    function GetKeyboardType: TVirtualKeyboardType; override;
    procedure setKeyboardType(const Value: TVirtualKeyboardType); override;
    function GetAutoCapitalizationType: TALAutoCapitalizationType; override;
    procedure setAutoCapitalizationType(const Value: TALAutoCapitalizationType); override;
    function GetPassword: Boolean; override;
    procedure setPassword(const Value: Boolean); override;
    function GetCheckSpelling: Boolean; override;
    procedure setCheckSpelling(const Value: Boolean); override;
    function GetReturnKeyType: TReturnKeyType; override;
    procedure setReturnKeyType(const Value: TReturnKeyType); override;
    function GetPromptText: String; override;
    procedure setPromptText(const Value: String); override;
    function GetPromptTextColor: TAlphaColor; override;
    procedure setPromptTextColor(const Value: TAlphaColor); override;
    function GetTintColor: TAlphaColor; override;
    procedure setTintColor(const Value: TAlphaColor); override;
    function GetFillColor: TAlphaColor; override;
    procedure SetFillColor(const Value: TAlphaColor); override;
    procedure TextSettingsChanged(Sender: TObject); override;
    function getText: String; override;
    procedure SetText(const Value: String); override;
    function GetMaxLength: integer; override;
    procedure SetMaxLength(const Value: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    function getLineHeight: Single; override; // It includes the line spacing
    property NativeView: TALWinEditView read GetNativeView;
  end;

{$endif}
{$ENDREGION}

type

  {******************}
  TALBaseEdit = class;

  {*******************************************}
  TALEditLabelTextLayout = (Floating, &Inline);
  TALEditLabelTextAnimation = (Translation, Opacity);

  {***************************************************}
  TALEditLabelTextSettings = class(TALBaseTextSettings)
  private
    FMargins: TBounds;
    FLayout: TALEditLabelTextLayout;
    FAnimation: TALEditLabelTextAnimation;
    procedure SetMargins(const Value: TBounds);
    procedure SetLayout(const Value: TALEditLabelTextLayout);
    procedure SetAnimation(const Value: TALEditLabelTextAnimation);
    procedure MarginsChanged(Sender: TObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Reset; override;
  published
    property Font;
    property Trimming;
    property MaxLines;
    property Ellipsis;
    property LineHeightMultiplier;
    property LetterSpacing;
    property IsHtml;
    property Margins: TBounds read FMargins write SetMargins;
    property Layout: TALEditLabelTextLayout read FLayout write SetLayout default TALEditLabelTextLayout.Floating;
    property Animation: TALEditLabelTextAnimation read FAnimation write SetAnimation default TALEditLabelTextAnimation.Translation;
  end;

  {************************************************}
  TALEditSupportingTextLayout = (Floating, &Inline);

  {********************************************************}
  TALEditSupportingTextSettings = class(TALBaseTextSettings)
  private
    FMargins: TBounds;
    FLayout: TALEditSupportingTextLayout;
    procedure SetMargins(const Value: TBounds);
    procedure SetLayout(const Value: TALEditSupportingTextLayout);
    procedure MarginsChanged(Sender: TObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Reset; override;
  published
    property Font;
    property Trimming;
    property MaxLines;
    property Ellipsis;
    property LineHeightMultiplier;
    property LetterSpacing;
    property IsHtml;
    property Margins: TBounds read FMargins write SetMargins;
    property Layout: TALEditSupportingTextLayout read FLayout write SetLayout default TALEditSupportingTextLayout.Floating;
  end;

  {***************************************************************}
  TALEditStateStyleTextSettings = class(TALInheritBaseTextSettings)
  published
    property Font;
  end;

  {**********************************************}
  TALEditBaseStateStyle = class(TALBaseStateStyle)
  private
    FPromptTextColor: TalphaColor;
    FTintColor: TalphaColor;
    FTextSettings: TALEditStateStyleTextSettings;
    FLabelTextSettings: TALEditStateStyleTextSettings;
    FSupportingTextSettings: TALEditStateStyleTextSettings;
    FPriorSupersedePromptTextColor: TalphaColor;
    FPriorSupersedeTintColor: TalphaColor;
    procedure SetPromptTextColor(const AValue: TAlphaColor);
    procedure SetTintColor(const AValue: TAlphaColor);
    procedure SetTextSettings(const AValue: TALEditStateStyleTextSettings);
    procedure SetLabelTextSettings(const AValue: TALEditStateStyleTextSettings);
    procedure SetSupportingTextSettings(const AValue: TALEditStateStyleTextSettings);
    procedure TextSettingsChanged(ASender: TObject);
    procedure LabelTextSettingsChanged(ASender: TObject);
    procedure SupportingTextSettingsChanged(ASender: TObject);
  protected
    function GetInherit: Boolean; override;
    procedure DoSupersede; override;
    procedure DoReinstate; override;
  public
    constructor Create(const AParent: TObject); reintroduce; virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    Property Inherit: Boolean read GetInherit;
  published
    property LabelTextSettings: TALEditStateStyleTextSettings read fLabelTextSettings write SetLabelTextSettings;
    property PromptTextColor: TAlphaColor read FPromptTextColor write SetPromptTextColor default TalphaColors.Null;
    property SupportingTextSettings: TALEditStateStyleTextSettings read fSupportingTextSettings write SetSupportingTextSettings;
    property TextSettings: TALEditStateStyleTextSettings read fTextSettings write SetTextSettings;
    property TintColor: TAlphaColor read FTintColor write SetTintColor default TalphaColors.Null;
  end;

  {******************************************************}
  TALEditDisabledStateStyle = class(TALEditBaseStateStyle)
  private
    FOpacity: Single;
    procedure SetOpacity(const Value: Single);
    function IsOpacityStored: Boolean;
  public
    constructor Create(const AParent: TObject); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Fill;
    // Opacity is not part of the GetInherit function because it updates the
    // disabledOpacity of the base control immediately every time it changes.
    // Essentially, it acts merely as a link to the disabledOpacity of the base control.
    property Opacity: Single read FOpacity write SetOpacity stored IsOpacityStored nodefault;
    property Shadow;
    property Stroke;
  end;

  {*****************************************************}
  TALEditHoveredStateStyle = class(TALEditBaseStateStyle)
  published
    property Fill;
    property Shadow;
    property StateLayer;
    property Stroke;
  end;

  {*****************************************************}
  TALEditFocusedStateStyle = class(TALEditBaseStateStyle)
  published
    property Fill;
    property Shadow;
    property StateLayer;
    property Stroke;
  end;

  {***********************************************}
  TALEditStateStyles = class(TALPersistentObserver)
  private
    FDisabled: TALEditDisabledStateStyle;
    FHovered: TALEditHoveredStateStyle;
    FFocused: TALEditFocusedStateStyle;
    procedure SetDisabled(const AValue: TALEditDisabledStateStyle);
    procedure SetHovered(const AValue: TALEditHoveredStateStyle);
    procedure SetFocused(const AValue: TALEditFocusedStateStyle);
    procedure DisabledChanged(ASender: TObject);
    procedure HoveredChanged(ASender: TObject);
    procedure FocusedChanged(ASender: TObject);
  public
    constructor Create(const AParent: TALBaseEdit); reintroduce; virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Disabled: TALEditDisabledStateStyle read FDisabled write SetDisabled;
    property Hovered: TALEditHoveredStateStyle read FHovered write SetHovered;
    property Focused: TALEditFocusedStateStyle read FFocused write SetFocused;
  end;

  {******************************************************************************}
  TALBaseEdit = class(TALBaseRectangle, IControlTypeSupportable, IALNativeControl)
  private
    fDefStyleAttr: String;
    fDefStyleRes: String;
    FAutoTranslate: Boolean;
    fOnChangeTracking: TNotifyEvent;
    fOnReturnKey: TNotifyEvent;
    fOnEnter: TNotifyEvent;
    fOnExit: TNotifyEvent;
    FTextSettings: TALEditTextSettings;
    FPromptText: String;
    FPromptTextColor: TAlphaColor;
    FTintcolor: TAlphaColor;
    FLabelText: String;
    FLabelTextSettings: TALEditLabelTextSettings;
    FlabelTextAnimation: TALFloatAnimation;
    FSupportingText: String;
    FSupportingTextSettings: TALEditSupportingTextSettings;
    FSupportingTextMarginBottomUpdated: Boolean;
    FHovered: Boolean;
    FStateStyles: TALEditStateStyles;
    FIsTextEmpty: Boolean;
    FNativeViewRemoved: Boolean;
    fEditControl: TALBaseEditControl;
    //--
    fBufDisabledDrawable: TALDrawable;
    fBufDisabledDrawableRect: TRectF;
    fBufHoveredDrawable: TALDrawable;
    fBufHoveredDrawableRect: TRectF;
    fBufFocusedDrawable: TALDrawable;
    fBufFocusedDrawableRect: TRectF;
    //--
    fBufPromptTextDrawable: TALDrawable;
    fBufPromptTextDrawableRect: TRectF;
    fBufPromptTextDisabledDrawable: TALDrawable;
    fBufPromptTextDisabledDrawableRect: TRectF;
    fBufPromptTextHoveredDrawable: TALDrawable;
    fBufPromptTextHoveredDrawableRect: TRectF;
    fBufPromptTextFocusedDrawable: TALDrawable;
    fBufPromptTextFocusedDrawableRect: TRectF;
    //--
    fBufLabelTextDrawable: TALDrawable;
    fBufLabelTextDrawableRect: TRectF;
    fBufLabelTextDisabledDrawable: TALDrawable;
    fBufLabelTextDisabledDrawableRect: TRectF;
    fBufLabelTextHoveredDrawable: TALDrawable;
    fBufLabelTextHoveredDrawableRect: TRectF;
    fBufLabelTextFocusedDrawable: TALDrawable;
    fBufLabelTextFocusedDrawableRect: TRectF;
    //--
    fBufSupportingTextDrawable: TALDrawable;
    fBufSupportingTextDrawableRect: TRectF;
    fBufSupportingTextDisabledDrawable: TALDrawable;
    fBufSupportingTextDisabledDrawableRect: TRectF;
    fBufSupportingTextHoveredDrawable: TALDrawable;
    fBufSupportingTextHoveredDrawableRect: TRectF;
    fBufSupportingTextFocusedDrawable: TALDrawable;
    fBufSupportingTextFocusedDrawableRect: TRectF;
    //--
    procedure UpdateEditControlPromptText;
    procedure UpdateNativeViewVisibility;
    function GetPromptText: String;
    procedure setPromptText(const Value: String);
    function GetPromptTextColor: TAlphaColor;
    procedure setPromptTextColor(const Value: TAlphaColor);
    procedure setLabelText(const Value: String);
    procedure setSupportingText(const Value: String);
    function GetTintColor: TAlphaColor;
    procedure setTintColor(const Value: TAlphaColor);
    procedure SetTextSettings(const Value: TALEditTextSettings);
    procedure SetLabelTextSettings(const Value: TALEditLabelTextSettings);
    procedure SetSupportingTextSettings(const Value: TALEditSupportingTextSettings);
    procedure SetStateStyles(const AValue: TALEditStateStyles);
    function getText: String;
    procedure SetText(const Value: String);
    function GetIsTextEmpty: Boolean; inline;
    procedure OnChangeTrackingImpl(Sender: TObject);
    procedure OnReturnKeyImpl(Sender: TObject);
    procedure SetOnReturnKey(const Value: TNotifyEvent);
    procedure OnEnterImpl(Sender: TObject);
    procedure OnExitImpl(Sender: TObject);
    procedure SetKeyboardType(Value: TVirtualKeyboardType);
    function GetKeyboardType: TVirtualKeyboardType;
    procedure setAutoCapitalizationType(const Value: TALAutoCapitalizationType);
    function GetAutoCapitalizationType: TALAutoCapitalizationType;
    procedure SetPassword(const Value: Boolean);
    function GetPassword: Boolean;
    procedure SetCheckSpelling(const Value: Boolean);
    function GetCheckSpelling: Boolean;
    procedure SetReturnKeyType(const Value: TReturnKeyType);
    function GetReturnKeyType: TReturnKeyType;
    procedure SetDefStyleAttr(const Value: String);
    procedure SetDefStyleRes(const Value: String);
    procedure SetMaxLength(const Value: integer);
    function GetMaxLength: integer;
    procedure LabelTextAnimationProcess(Sender: TObject);
    procedure LabelTextAnimationFinish(Sender: TObject);
    function HasOpacityLabelTextAnimation: Boolean;
    function HasTranslationLabelTextAnimation: Boolean;
    procedure UpdateEditControlStyle;
    procedure SetHovered(const AValue: Boolean);
    { IControlTypeSupportable }
    function GetControlType: TControlType;
    procedure SetControlType(const Value: TControlType);
  protected
    FIsAdjustingSize: Boolean;
    function CreateTextSettings: TALEditTextSettings; virtual;
    function CreateEditControl: TALBaseEditControl; virtual;
    function GetEditControl: TALBaseEditControl; virtual;
    property EditControl: TALBaseEditControl read GetEditControl;
    {$IF defined(android)}
    function GetNativeView: TALAndroidNativeView; virtual;
    {$ELSEIF defined(IOS)}
    function GetNativeView: TALIosNativeView; virtual;
    {$ELSEIF defined(ALMacOS)}
    function GetNativeView: TALMacNativeView; virtual;
    {$ELSEIF defined(MSWindows)}
    function GetNativeView: TALWinNativeView; virtual;
    {$ENDIF}
    procedure InitEditControl; virtual;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure DoMouseEnter; override;
    procedure DoMouseLeave; override;
    function GetDefaultSize: TSizeF; override;
    procedure Loaded; override;
    procedure TextSettingsChanged(Sender: TObject); virtual;
    procedure LabelTextSettingsChanged(Sender: TObject); virtual;
    procedure SupportingTextSettingsChanged(Sender: TObject); virtual;
    procedure StateStylesChanged(Sender: TObject); virtual;
    procedure EnabledChanged; override;
    procedure PaddingChanged; override;
    procedure StrokeChanged(Sender: TObject); override;
    procedure SetSides(const Value: TSides); override;
    procedure FillChanged(Sender: TObject); override;
    procedure DoResized; override;
    procedure AdjustSize; virtual; abstract;
    procedure Paint; override;
    Procedure CreateBufPromptTextDrawable(
                var ABufDrawable: TALDrawable;
                var ABufDrawableRect: TRectF;
                const AText: String;
                const AFont: TALFont);
    Procedure CreateBufLabelTextDrawable(
                var ABufDrawable: TALDrawable;
                var ABufDrawableRect: TRectF;
                const AText: String;
                const AFont: TALFont);
    Procedure CreateBufSupportingTextDrawable(
                var ABufDrawable: TALDrawable;
                var ABufDrawableRect: TRectF;
                const AText: String;
                const AFont: TALFont);
    property BufPromptTextDrawable: TALDrawable read fBufPromptTextDrawable;
    property BufPromptTextDrawableRect: TRectF read fBufPromptTextDrawableRect;
    property BufLabelTextDrawable: TALDrawable read fBufLabelTextDrawable;
    property BufLabelTextDrawableRect: TRectF read fBufLabelTextDrawableRect;
    property BufSupportingTextDrawable: TALDrawable read fBufSupportingTextDrawable;
    property BufSupportingTextDrawableRect: TRectF read fBufSupportingTextDrawableRect;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {$IF defined(android)}
    property NativeView: TALAndroidNativeView read GetNativeView;
    {$ELSEIF defined(IOS)}
    property NativeView: TALIosNativeView read GetNativeView;
    {$ELSEIF defined(ALMacOS)}
    property NativeView: TALMacNativeView read GetNativeView;
    {$ELSEIF defined(MSWindows)}
    property NativeView: TALWinNativeView read GetNativeView;
    {$ENDIF}
    function HasNativeView: boolean;
    Procedure AddNativeView;
    Procedure RemoveNativeView;
    function getLineCount: integer;
    function getLineHeight: Single; // It includes the line spacing
    procedure MakeBufDrawable; override;
    procedure MakeBufPromptTextDrawable; virtual;
    procedure MakeBufLabelTextDrawable; virtual;
    procedure MakeBufSupportingTextDrawable; virtual;
    procedure clearBufDrawable; override;
    procedure clearBufPromptTextDrawable; virtual;
    procedure clearBufLabelTextDrawable; virtual;
    procedure clearBufSupportingTextDrawable; virtual;
    property Password: Boolean read GetPassword write SetPassword default False;
  published
    // Android only - the name of an attribute in the current theme that contains a reference to
    // a style resource that supplies defaults style values
    // Exemple of use: https://stackoverflow.com/questions/5051753/how-do-i-apply-a-style-programmatically
    // NOTE: !!IMPORTANT!! This properties must be defined the very first because the stream system must load it the very first
    property DefStyleAttr: String read fDefStyleAttr write SetDefStyleAttr;
    // Android only - the name of a style resource that supplies default style values
    // NOTE: !!IMPORTANT!! This properties must be defined the very first because the stream system must load it the very first
    property DefStyleRes: String read fDefStyleRes write SetDefStyleRes;
    property AutoCapitalizationType: TALAutoCapitalizationType read GetAutoCapitalizationType write SetAutoCapitalizationType default TALAutoCapitalizationType.acNone;
    property AutoTranslate: Boolean read FAutoTranslate write FAutoTranslate default true; // Just the PromptText
    property CanFocus default True;
    //property CanParentFocus;
    //property Caret;
    property CheckSpelling: Boolean read GetCheckSpelling write SetCheckSpelling default true;
    property Cursor default crIBeam;
    //property DisableFocusEffect;
    //property FilterChar;
    //property Hint;
    //property ParentShowHint;
    //property ShowHint;
    property KeyboardType: TVirtualKeyboardType read GetKeyboardType write SetKeyboardType default TVirtualKeyboardType.Default;
    //property KillFocusByReturn; => always true
    property LabelText: String read FLabelText write SetLabelText;
    property LabelTextSettings: TALEditLabelTextSettings read FLabelTextSettings write SetLabelTextSettings;
    property MaxLength: integer read GetMaxLength write SetMaxLength default 0;
    property PromptText: String read GetPromptText write setPromptText;
    property PromptTextColor: TAlphaColor read GetPromptTextColor write setPromptTextColor default TalphaColors.null; // Null mean use the default PromptTextColor
    //property ReadOnly;
    property ReturnKeyType: TReturnKeyType read GetReturnKeyType write SetReturnKeyType default TReturnKeyType.Default;
    property StateStyles: TALEditStateStyles read FStateStyles write SetStateStyles;
    property SupportingText: String read FSupportingText write SetSupportingText;
    property SupportingTextSettings: TALEditSupportingTextSettings read FSupportingTextSettings write SetSupportingTextSettings;
    property TabOrder;
    property TabStop;
    property Text: String read getText write SetText;
    property TextSettings: TALEditTextSettings read FTextSettings write SetTextSettings;
    property TintColor: TAlphaColor read GetTintColor write setTintColor default TalphaColors.null; // IOS only - the color of the cursor caret and the text selection handles. null mean use the default TintColor
    property TouchTargetExpansion;
    //property OnChange;
    property OnChangeTracking: TNotifyEvent read fOnChangeTracking write fOnChangeTracking;
    property OnEnter: TnotifyEvent Read fOnEnter Write fOnEnter;
    property OnExit: TnotifyEvent Read fOnExit Write fOnExit;
    //property OnKeyDown; // Not work under android - it's like this with their @{[^# virtual keyboard :(
    //property OnKeyUp; // Not work under android - it's like this with their @{[^# virtual keyboard :(
    property OnReturnKey: TNotifyEvent read fOnReturnKey write SetOnReturnKey;
    //property OnTyping;
    //property OnValidate;
    //property OnValidating;
  end;

  {*************************}
  [ComponentPlatforms($FFFF)]
  TALEdit = class(TALBaseEdit, IALAutosizeControl)
  private
    FAutoSize: Boolean;
  protected
    function GetAutoSize: Boolean; virtual;
    procedure SetAutoSize(const Value: Boolean); virtual;
    procedure AdjustSize; override;
    { IALAutosizeControl }
    function HasUnconstrainedAutosizeX: Boolean; virtual;
    function HasUnconstrainedAutosizeY: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AutoSize: Boolean read GetAutoSize write SetAutoSize default True;
    property Password;
  end;

procedure Register;

implementation

uses
  System.SysUtils,
  System.Math,
  System.Math.Vectors,
  FMX.Types3D,
  FMX.Utils,
  {$IF defined(android)}
  Androidapi.Helpers,
  Androidapi.Input,
  Androidapi.KeyCodes,
  Androidapi.JNI.App,
  Androidapi.JNI.Util,
  Androidapi.JNI.Os,
  FMX.Platform,
  FMX.Platform.Android,
  {$ELSEIF defined(IOS)}
  Macapi.CoreFoundation,
  iOSapi.CocoaTypes,
  Macapi.Helpers,
  iOSapi.CoreText,
  FMX.Helpers.iOS,
  FMX.Consts,
  {$ELSEIF defined(ALMacOS)}
  Macapi.CoreFoundation,
  Macapi.Helpers,
  FMX.Helpers.Mac,
  FMX.Consts,
  Alcinoe.StringUtils,
  {$ELSEIF defined(MSWINDOWS)}
  Winapi.CommCtrl,
  Fmx.Forms,
  {$endif}
  {$IF defined(ALSkiaCanvas)}
  System.Skia.API,
  {$endif}
  {$IFDEF ALDPK}
  DesignIntf,
  {$ENDIF}
  Alcinoe.FMX.Memo,
  Alcinoe.FMX.BreakText,
  Alcinoe.Common;

{********************************************************}
constructor TALBaseEditControl.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  CanFocus := True;
  fOnChangeTracking := nil;
  FOnReturnKey := nil;
  FTextSettings := TALEditTextSettings.Create;
  FTextSettings.OnChanged := TextSettingsChanged;
  FNativeView := CreateNativeView;
end;

{********************************}
destructor TALBaseEditControl.Destroy;
begin
  ALFreeAndNil(FTextSettings);
  ALFreeAndNil(FNativeView);
  inherited Destroy;
end;

{**********************}
{$IF defined(android)}
function TALBaseEditControl.GetNativeView: TALAndroidNativeView;
begin
  Result := FNativeView;
end;
{$ENDIF}

{**********************}
{$IF defined(IOS)}
function TALBaseEditControl.GetNativeView: TALIosNativeView;
begin
  Result := FNativeView;
end;
{$ENDIF}

{**********************}
{$IF defined(ALMacOS)}
function TALBaseEditControl.GetNativeView: TALMacNativeView;
begin
  Result := FNativeView;
end;
{$ENDIF}

{**********************}
{$IF defined(MSWindows)}
function TALBaseEditControl.GetNativeView: TALWinNativeView;
begin
  Result := FNativeView;
end;
{$ENDIF}

{*******************************************************************}
procedure TALBaseEditControl.SetTextSettings(const Value: TALEditTextSettings);
begin
  FTextSettings.Assign(Value);
end;

{********************************************}
procedure TALBaseEditControl.DoChangeTracking;
begin
  if assigned(fOnChangeTracking) then
    fOnChangeTracking(self);
end;

{****************************************}
procedure TALBaseEditControl.DoReturnKey;
begin
  if assigned(fOnReturnKey) then
    fOnReturnKey(self);
end;

{*************************************}
procedure TALBaseEditControl.DoRootChanged;
begin
  inherited;
  if csDestroying in ComponentState then exit;
  {$IF not defined(ALDPK)}
  NativeView.RootChanged(Root);
  {$ENDIF}
end;

{******************************}
procedure TALBaseEditControl.Resize;
begin
  inherited;
  {$IF not defined(ALDPK)}
  NativeView.UpdateFrame;
  {$ENDIF}
end;

{*****************************************}
procedure TALBaseEditControl.DoAbsoluteChanged;
begin
  inherited;
  {$IF not defined(ALDPK)}
  if not (csLoading in ComponentState) then
    NativeView.UpdateFrame;
  {$ENDIF}
end;

{**************************************}
procedure TALBaseEditControl.VisibleChanged;
begin
  inherited;
  {$IF not defined(ALDPK)}
  NativeView.SetVisible(Visible);
  {$ENDIF}
end;

{***********************************}
procedure TALBaseEditControl.ChangeOrder;
begin
  inherited;
  {$IF not defined(ALDPK)}
  NativeView.ChangeOrder;
  {$ENDIF}
end;

{*************************************}
procedure TALBaseEditControl.RecalcOpacity;
begin
  inherited;
  {$IF not defined(ALDPK)}
  NativeView.setAlpha(AbsoluteOpacity);
  {$ENDIF}
end;

{*************************************}
procedure TALBaseEditControl.RecalcEnabled;
begin
  inherited;
  {$IF not defined(ALDPK)}
  NativeView.SetEnabled(AbsoluteEnabled);
  {$ENDIF}
end;

{*********************************************}
function TALBaseEditControl.HasNativeView: boolean;
begin
  {$IF not defined(ALDPK)}
  Result := NativeView.Visible;
  {$ELSE}
  Result := false;
  {$ENDIF}
end;

{*************************************}
Procedure TALBaseEditControl.AddNativeView;
begin
  {$IF not defined(ALDPK)}
  NativeView.SetVisible(true);
  {$ENDIF}
end;

{****************************************}
Procedure TALBaseEditControl.RemoveNativeView;
begin
  {$IF not defined(ALDPK)}
  NativeView.SetVisible(False);
  {$ENDIF}
end;

{**********************************************************************}
procedure TALBaseEditControl.AncestorVisibleChanged(const Visible: Boolean);
begin
  inherited;
  {$IF not defined(ALDPK)}
  NativeView.AncestorVisibleChanged;
  {$ENDIF}
end;

{*********************************************}
procedure TALBaseEditControl.AncestorParentChanged;
begin
  inherited;
  if csDestroying in ComponentState then exit;
  {$IF not defined(ALDPK)}
  NativeView.UpdateFrame;
  {$ENDIF}
end;

{*************************************}
procedure TALBaseEditControl.ParentChanged;
begin
  inherited;
  if csDestroying in ComponentState then exit;
  {$IF not defined(ALDPK)}
  NativeView.UpdateFrame;
  {$ENDIF}
end;

{***********************************}
procedure TALBaseEditControl.DoEndUpdate;
begin
  inherited;
  if csDestroying in ComponentState then exit;
  // Without this, in some case when we are doing beginupdate to the TEdit
  // (because in android for exemple we would like to not refresh the position of the control during calculation)
  // then when we do endupdate the control is not paint or lost somewhere
  {$IF not defined(ALDPK)}
  NativeView.UpdateFrame;
  {$ENDIF}
end;

{************************************************}
function TALBaseEditControl.getLineCount: integer;
begin
  Result := 1;
end;

{$REGION ' ANDROID'}
{$IF defined(android)}

{**********************************************************************************************}
constructor TALAndroidEditText.TALKeyPreImeListener.Create(const aEditText: TALAndroidEditText);
begin
  inherited Create;
  FEditText := aEditText;
end;

{********************************************************************************************************}
function TALAndroidEditText.TALKeyPreImeListener.onKeyPreIme(keyCode: Integer; event: JKeyEvent): Boolean;
begin
  {$IF defined(DEBUG)}
  if event <> nil then
    ALLog(
      'TALAndroidEditText.TALKeyPreImeListener.onKeyPreIme',
      'control.name: ' + FEditText.FEditControl.parent.Name + ' | ' +
      'keyCode: ' + inttostr(keyCode) + ' | ' +
      'event: ' + JstringToString(event.toString),
      TalLogType.VERBOSE)
  else
    ALLog(
      'TALAndroidEditText.TALKeyPreImeListener.onKeyPreIme',
      'control.name: ' + FEditText.FEditControl.parent.Name + ' | ' +
      'keyCode: ' + inttostr(keyCode),
      TalLogType.VERBOSE);
  {$ENDIF}
  if ((event = nil) or (event.getAction = AKEY_EVENT_ACTION_UP)) and
     (keyCode = AKEYCODE_BACK) then begin

    result := true;
    FEditText.FEditcontrol.resetfocus;

  end
  else result := false;
end;

{******************************************************************************************}
constructor TALAndroidEditText.TALTouchListener.Create(const aEditText: TALAndroidEditText);
begin
  inherited Create;
  FEditText := aEditText;
end;

{*************************************}
{$IFNDEF ALCompilerVersionSupported120}
  {$MESSAGE WARN 'Check if FMX.Presentation.Android.TAndroidNativeView.ProcessTouch was not updated and adjust the IFDEF'}
{$ENDIF}
function TALAndroidEditText.TALTouchListener.onTouch(v: JView; event: JMotionEvent): Boolean;
begin
  if (FEditText.Form <> nil) and
     (not FeditText.view.hasFocus) and
     ((not FeditText.fIsMultiline) or
      (FeditText.FEditControl.getLineCount < FeditText.FeditControl.Height / FeditText.FeditControl.getLineHeight)) then begin
    var LTouchPoint := TPointF.Create(event.getRawX / ALGetScreenScale, event.getRawY / ALGetScreenScale);
    LTouchPoint := FEditText.Form.ScreenToClient(LTouchPoint);
    var LEventAction := event.getAction;
    if LEventAction = TJMotionEvent.JavaClass.ACTION_DOWN then begin
      FEditText.Form.MouseMove([ssTouch], LTouchPoint.X, LTouchPoint.Y);
      FEditText.Form.MouseMove([], LTouchPoint.X, LTouchPoint.Y); // Require for correct IsMouseOver handle
      FEditText.Form.MouseDown(TMouseButton.mbLeft, [ssLeft, ssTouch], LTouchPoint.x, LTouchPoint.y);
    end
    else if LEventAction = TJMotionEvent.JavaClass.ACTION_MOVE then begin
      FEditText.Form.MouseMove([ssLeft, ssTouch], LTouchPoint.x, LTouchPoint.y)
    end
    else if LEventAction = TJMotionEvent.JavaClass.ACTION_CANCEL then begin
      FEditText.Form.MouseUp(TMouseButton.mbLeft, [ssLeft, ssTouch], LTouchPoint.x, LTouchPoint.y, False);
      FEditText.Form.MouseLeave;
    end
    else if LEventAction = TJMotionEvent.JavaClass.ACTION_UP then
    begin
      FEditText.Form.MouseUp(TMouseButton.mbLeft, [ssLeft, ssTouch], LTouchPoint.x, LTouchPoint.y);
      FEditText.Form.MouseLeave;
    end;
    Result := True;
  end
  else begin
    // In Android, within a single-line EditText, it's possible for the text line to shift slightly vertically
    // (as if the text is taller than the line height). To prevent this minor scrolling, we consume the touch event.
    if (not FeditText.fIsMultiline) and (FeditText.view.hasFocus) and (event.getAction() = TJMotionEvent.JavaClass.ACTION_MOVE) then result := true
    else result := false;
  end
end;

{****************************************************************************************}
constructor TALAndroidEditText.TALTextWatcher.Create(const aEditText: TALAndroidEditText);
begin
  inherited Create;
  FEditText := aEditText;
end;

{*************************************************************************}
procedure TALAndroidEditText.TALTextWatcher.afterTextChanged(s: JEditable);
begin
  {$IF defined(DEBUG)}
  ALLog('TALAndroidEditText.TALTextWatcher.afterTextChanged', 'control.name: ' + FEditText.FEditControl.parent.Name, TalLogType.VERBOSE);
  {$ENDIF}
  FEditText.fEditControl.DoChangeTracking;
end;

{******************************************************************************************************************************}
procedure TALAndroidEditText.TALTextWatcher.beforeTextChanged(s: JCharSequence; start: Integer; count: Integer; after: Integer);
begin
  // Nothing to do
end;

{***************************************************************************************************************************}
procedure TALAndroidEditText.TALTextWatcher.onTextChanged(s: JCharSequence; start: Integer; before: Integer; count: Integer);
begin
  // Nothing to do
end;

{**********************************************************************************************************************************************}
constructor TALAndroidEditText.TALEditorActionListener.Create(const aEditText: TALAndroidEditText; const aIsMultiLineEditText: Boolean = false);
begin
  inherited Create;
  fIsMultiLineEditText := aIsMultiLineEditText;
  FEditText := aEditText;
end;

{*****************************************************************************************************************************}
function TALAndroidEditText.TALEditorActionListener.onEditorAction(v: JTextView; actionId: Integer; event: JKeyEvent): Boolean;
begin
  {$IF defined(DEBUG)}
   if event <> nil then
     ALLog(
       'TALAndroidEditText.TALEditorActionListener.onEditorAction',
       'control.name: ' + FEditText.FEditControl.parent.Name + ' | ' +
       'actionId: ' + inttostr(actionId) + ' | ' +
       'event: ' + JstringToString(event.toString),
       TalLogType.VERBOSE)
   else
     ALLog(
       'TALAndroidEditText.TALEditorActionListener.onEditorAction',
       'control.name: ' + FEditText.FEditControl.parent.Name + ' | ' +
       'actionId: ' + inttostr(actionId),
       TalLogType.VERBOSE);
  {$ENDIF}
  //IME_ACTION_DONE: the action key performs a "done" operation, typically meaning there is nothing more to input and the IME will be closed.
  //IME_ACTION_GO: the action key performs a "go" operation to take the user to the target of the text they typed. Typically used, for example, when entering a URL.
  //IME_ACTION_NEXT: the action key performs a "next" operation, taking the user to the next field that will accept text.
  //IME_ACTION_NONE: there is no available action.
  //IME_ACTION_PREVIOUS: like IME_ACTION_NEXT, but for moving to the previous field. This will normally not be used to specify an action (since it precludes IME_ACTION_NEXT), but can be returned to the app if it sets IME_FLAG_NAVIGATE_PREVIOUS.
  //IME_ACTION_SEARCH: the action key performs a "search" operation, taking the user to the results of searching for the text they have typed (in whatever context is appropriate).
  //IME_ACTION_SEND: the action key performs a "send" operation, delivering the text to its target. This is typically used when composing a message in IM or SMS where sending is immediate.
  //IME_ACTION_UNSPECIFIED: no specific action has been associated with this editor, let the editor come up with its own if it can.
  if (assigned(FEditText.FEditControl.OnReturnKey)) and
     (((actionId = TJEditorInfo.javaClass.IME_ACTION_UNSPECIFIED) and // IME_ACTION_UNSPECIFIED = the return key
       (not fIsMultiLineEditText)) or
      (actionId = TJEditorInfo.javaClass.IME_ACTION_DONE) or
      (actionId = TJEditorInfo.javaClass.IME_ACTION_GO) or
      (actionId = TJEditorInfo.javaClass.IME_ACTION_NEXT) or
      (actionId = TJEditorInfo.javaClass.IME_ACTION_SEARCH) or
      (actionId = TJEditorInfo.javaClass.IME_ACTION_SEND)) then begin

    result := true;
    FEditText.FEditControl.DoReturnKey;

  end
  else result := false;
end;

{***********************************************************************************************************************************************************************************}
constructor TALAndroidEditText.Create(const AControl: TALAndroidEditControl; Const aIsMultiline: Boolean = False; const aDefStyleAttr: String = ''; const aDefStyleRes: String = '');
begin
  fIsMultiline := aIsMultiline;
  fDefStyleAttr := aDefStyleAttr;
  fDefStyleRes := aDefStyleRes;
  FTextWatcher := TALTextWatcher.Create(self);
  FEditorActionListener := TALEditorActionListener.Create(self, aIsMultiline);
  FKeyPreImeListener := TALKeyPreImeListener.Create(self);
  FTouchListener := TALTouchListener.Create(self);
  fEditControl := TALAndroidEditControl(AControl);
  inherited create(AControl);  // This will call InitView
end;

{************************************}
destructor TALAndroidEditText.Destroy;
begin

  View.setVisibility(TJView.JavaClass.INVISIBLE);
  View.RemoveTextChangedListener(FTextWatcher);
  View.setOnEditorActionListener(nil);
  View.SetKeyPreImeListener(nil);
  View.SetOnTouchListener(nil);

  alfreeandNil(FTextWatcher);
  alfreeandNil(fEditorActionListener);
  alfreeandNil(FKeyPreImeListener);
  alfreeandNil(FTouchListener);

  inherited;

end;

{********************************************}
function TALAndroidEditText.CreateView: JView;
begin
  var LSDKVersion := TJBuild_VERSION.JavaClass.SDK_INT;
  //-----
  if (fDefStyleAttr = '') and
     ((LSDKVersion < 22{lollipop}) or (fDefStyleRes='')) then
    Result := TJALEditText.JavaClass.init(TAndroidHelper.Activity)
  //-----
  else if (LSDKVersion < 22{lollipop}) or (fDefStyleRes='')  then
    Result := TJALEditText.JavaClass.init(
                TAndroidHelper.Activity, // context: JContext;
                nil, // attrs: JAttributeSet;
                TAndroidHelper. // defStyleAttr: Integer
                  Context.
                    getResources().
                      getIdentifier(
                        StringToJstring(fDefStyleAttr), // name	String: The name of the desired resource.
                        StringToJstring('attr'), // String: Optional default resource type to find, if "type/" is not included in the name. Can be null to require an explicit type.
                        TAndroidHelper.Context.getPackageName())) // String: Optional default package to find, if "package:" is not included in the name. Can be null to require an explicit package.
  //-----
  else if (fDefStyleAttr = '') then
    Result := TJALEditText.JavaClass.init(
                TAndroidHelper.Activity, // context: JContext;
                nil, // attrs: JAttributeSet;
                0, // defStyleAttr: Integer
                TAndroidHelper. // defStyleRes: Integer
                  Context.
                    getResources().
                      getIdentifier(
                        StringToJstring(fDefStyleRes), // name	String: The name of the desired resource.
                        StringToJstring('style'), // String: Optional default resource type to find, if "type/" is not included in the name. Can be null to require an explicit type.
                        TAndroidHelper.Context.getPackageName())) // String: Optional default package to find, if "package:" is not included in the name. Can be null to require an explicit package.
  //-----
  else
    Result := TJALEditText.JavaClass.init(
                TAndroidHelper.Activity, // context: JContext;
                nil, // attrs: JAttributeSet;
                TAndroidHelper. // defStyleAttr: Integer
                  Context.
                    getResources().
                      getIdentifier(
                        StringToJstring(fDefStyleAttr), // name	String: The name of the desired resource.
                        StringToJstring('attr'), // String: Optional default resource type to find, if "type/" is not included in the name. Can be null to require an explicit type.
                        TAndroidHelper.Context.getPackageName()), // String: Optional default package to find, if "package:" is not included in the name. Can be null to require an explicit package.
                TAndroidHelper. // defStyleRes: Integer
                  Context.
                    getResources().
                      getIdentifier(
                        StringToJstring(fDefStyleRes), // name	String: The name of the desired resource.
                        StringToJstring('style'), // String: Optional default resource type to find, if "type/" is not included in the name. Can be null to require an explicit type.
                        TAndroidHelper.Context.getPackageName())) // String: Optional default package to find, if "package:" is not included in the name. Can be null to require an explicit package.
end;

{************************************}
procedure TALAndroidEditText.InitView;
begin
  inherited;
  //-----
  if fIsMultiline then View.setSingleLine(False)
  else View.setSingleLine(True);
  View.setClickable(True);
  View.setFocusable(True);
  View.setFocusableInTouchMode(True);
  //-----
  View.addTextChangedListener(fTextWatcher);
  View.setOnEditorActionListener(fEditorActionListener);
  View.SetKeyPreImeListener(fKeyPreImeListener);
  View.SetOnTouchListener(fTouchListener);
end;

{***********************************************}
function TALAndroidEditText.GetView: JALEditText;
begin
  Result := inherited GetView<JALEditText>;
end;

{*************************************************************************************************************************************************************************}
constructor TALAndroidEditControl.Create(const AOwner: TComponent; Const AIsMultiline: Boolean = False; const ADefStyleAttr: String = ''; const ADefStyleRes: String = '');
begin
  FDefStyleAttr := ADefStyleAttr;
  FDefStyleRes := ADefStyleRes;
  fIsMultiline := aIsMultiline;
  inherited create(AOwner);
  FFillColor := $ffffffff;
  fMaxLength := 0;
  fApplicationEventMessageID := TMessageManager.DefaultManager.SubscribeToMessage(TApplicationEventMessage, ApplicationEventHandler);
  fReturnKeyType := tReturnKeyType.Default;
  fKeyboardType := TVirtualKeyboardType.default;
  fAutoCapitalizationType := TALAutoCapitalizationType.acNone;
  fPassword := false;
  fCheckSpelling := true;
  FTintColor := TalphaColors.Null;
  DoSetReturnKeyType(fReturnKeyType);
  DoSetInputType(fKeyboardType, fAutoCapitalizationType, fPassword, fCheckSpelling, fIsMultiline);
end;

{********************************}
destructor TALAndroidEditControl.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TApplicationEventMessage, fApplicationEventMessageID);
  inherited Destroy;
end;

{********************************************************************}
Function TALAndroidEditControl.CreateNativeView: TALAndroidNativeView;
begin
  result := TALAndroidEditText.create(self, FIsMultiline, FDefStyleAttr, FDefStyleRes);
  result.view.setBackgroundColor(TJColor.JavaClass.TRANSPARENT);
  result.view.setBackground(nil);
  result.view.setPadding(0, 0, 0, 0);
end;

{********************************************************}
function TALAndroidEditControl.GetNativeView: TALAndroidEditText;
begin
  result := TALAndroidEditText(inherited GetNativeView);
end;

{**************************************}
procedure TALAndroidEditControl.DoSetInputType(
            const aKeyboardType: TVirtualKeyboardType;
            const aAutoCapitalizationType: TALAutoCapitalizationType;
            const aPassword: Boolean;
            const aCheckSpelling: Boolean;
            const aIsMultiline: Boolean);
begin

  // TYPE_CLASS_DATETIME: Class for dates and times.
  // TYPE_CLASS_NUMBER: Class for numeric text.
  // TYPE_CLASS_PHONE: Class for a phone number.
  // TYPE_CLASS_TEXT: Class for normal text.
  // TYPE_DATETIME_VARIATION_DATE: Default variation of TYPE_CLASS_DATETIME: allows entering only a date.
  // TYPE_DATETIME_VARIATION_NORMAL: Default variation of TYPE_CLASS_DATETIME: allows entering both a date and time.
  // TYPE_DATETIME_VARIATION_TIME: Default variation of TYPE_CLASS_DATETIME: allows entering only a time.
  // TYPE_MASK_CLASS: Mask of bits that determine the overall class of text being given.
  // TYPE_MASK_FLAGS: Mask of bits that provide addition bit flags of options.
  // TYPE_MASK_VARIATION: Mask of bits that determine the variation of the base content class.
  // TYPE_NULL: Special content type for when no explicit type has been specified.
  // TYPE_NUMBER_FLAG_DECIMAL: Flag of TYPE_CLASS_NUMBER: the number is decimal, allowing a decimal point to provide fractional values.
  // TYPE_NUMBER_FLAG_SIGNED: Flag of TYPE_CLASS_NUMBER: the number is signed, allowing a positive or negative sign at the start.
  // TYPE_NUMBER_VARIATION_NORMAL: Default variation of TYPE_CLASS_NUMBER: plain normal numeric text.
  // TYPE_NUMBER_VARIATION_PASSWORD: Variation of TYPE_CLASS_NUMBER: entering a numeric password.
  // TYPE_TEXT_FLAG_AUTO_COMPLETE: Flag for TYPE_CLASS_TEXT: the text editor (which means the application) is performing auto-completion of the text being entered based on its own semantics, which it will present to the user as they type.
  // TYPE_TEXT_FLAG_AUTO_CORRECT: Flag for TYPE_CLASS_TEXT: the user is entering free-form text that should have auto-correction applied to it.
  // TYPE_TEXT_FLAG_CAP_CHARACTERS: Flag for TYPE_CLASS_TEXT: capitalize all characters.
  // TYPE_TEXT_FLAG_CAP_SENTENCES: Flag for TYPE_CLASS_TEXT: capitalize the first character of each sentence.
  // TYPE_TEXT_FLAG_CAP_WORDS: Flag for TYPE_CLASS_TEXT: capitalize the first character of every word.
  // TYPE_TEXT_FLAG_IME_MULTI_LINE: Flag for TYPE_CLASS_TEXT: the regular text view associated with this should not be multi-line, but when a fullscreen input method is providing text it should use multiple lines if it can.
  // TYPE_TEXT_FLAG_MULTI_LINE: Flag for TYPE_CLASS_TEXT: multiple lines of text can be entered into the field.
  // TYPE_TEXT_FLAG_NO_SUGGESTIONS: Flag for TYPE_CLASS_TEXT: the input method does not need to display any dictionary-based candidates.
  // TYPE_TEXT_VARIATION_EMAIL_ADDRESS: Variation of TYPE_CLASS_TEXT: entering an e-mail address.
  // TYPE_TEXT_VARIATION_EMAIL_SUBJECT: Variation of TYPE_CLASS_TEXT: entering the subject line of an e-mail.
  // TYPE_TEXT_VARIATION_FILTER: Variation of TYPE_CLASS_TEXT: entering text to filter contents of a list etc.
  // TYPE_TEXT_VARIATION_LONG_MESSAGE: Variation of TYPE_CLASS_TEXT: entering the content of a long, possibly formal message such as the body of an e-mail.
  // TYPE_TEXT_VARIATION_NORMAL: Default variation of TYPE_CLASS_TEXT: plain old normal text.
  // TYPE_TEXT_VARIATION_PASSWORD: Variation of TYPE_CLASS_TEXT: entering a password.
  // TYPE_TEXT_VARIATION_PERSON_NAME: Variation of TYPE_CLASS_TEXT: entering the name of a person.
  // TYPE_TEXT_VARIATION_PHONETIC: Variation of TYPE_CLASS_TEXT: entering text for phonetic pronunciation, such as a phonetic name field in contacts.
  // TYPE_TEXT_VARIATION_POSTAL_ADDRESS: Variation of TYPE_CLASS_TEXT: entering a postal mailing address.
  // TYPE_TEXT_VARIATION_SHORT_MESSAGE: Variation of TYPE_CLASS_TEXT: entering a short, possibly informal message such as an instant message or a text message.
  // TYPE_TEXT_VARIATION_URI: Variation of TYPE_CLASS_TEXT: entering a URI.
  // TYPE_TEXT_VARIATION_VISIBLE_PASSWORD: Variation of TYPE_CLASS_TEXT: entering a password, which should be visible to the user.
  // TYPE_TEXT_VARIATION_WEB_EDIT_TEXT: Variation of TYPE_CLASS_TEXT: entering text inside of a web form.
  // TYPE_TEXT_VARIATION_WEB_EMAIL_ADDRESS: Variation of TYPE_CLASS_TEXT: entering e-mail address inside of a web form.
  // TYPE_TEXT_VARIATION_WEB_PASSWORD: Variation of TYPE_CLASS_TEXT: entering password inside of a web form.

  var LInputType: integer;
  case aKeyboardType of
    TVirtualKeyboardType.Alphabet:              LInputType := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_FLAG_NO_SUGGESTIONS;
    TVirtualKeyboardType.URL:                   LInputType := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_URI;
    TVirtualKeyboardType.NamePhonePad:          LInputType := TJInputType.JavaClass.TYPE_CLASS_TEXT;
    TVirtualKeyboardType.EmailAddress:          LInputType := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_EMAIL_ADDRESS;
    TVirtualKeyboardType.NumbersAndPunctuation: LInputType := TJInputType.JavaClass.TYPE_CLASS_NUMBER or TJInputType.JavaClass.TYPE_NUMBER_FLAG_DECIMAL;
    TVirtualKeyboardType.NumberPad:             LInputType := TJInputType.JavaClass.TYPE_CLASS_NUMBER;
    TVirtualKeyboardType.PhonePad:              LInputType := TJInputType.JavaClass.TYPE_CLASS_PHONE;
    else {TVirtualKeyboardType.Default}         LInputType := TJInputType.JavaClass.TYPE_CLASS_TEXT;
  end;

  case aAutoCapitalizationType of
    TALAutoCapitalizationType.acNone:;
    TALAutoCapitalizationType.acWords:         LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_FLAG_CAP_WORDS;
    TALAutoCapitalizationType.acSentences:     LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_FLAG_CAP_SENTENCES;
    TALAutoCapitalizationType.acAllCharacters: LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_FLAG_CAP_CHARACTERS;
  end;

  if aPassword then begin
    case aKeyboardType of
      TVirtualKeyboardType.NumbersAndPunctuation: LInputType := LInputType or TJInputType.JavaClass.TYPE_NUMBER_VARIATION_PASSWORD;
      TVirtualKeyboardType.NumberPad:             LInputType := LInputType or TJInputType.JavaClass.TYPE_NUMBER_VARIATION_PASSWORD;
      TVirtualKeyboardType.PhonePad:;
      TVirtualKeyboardType.Alphabet:              LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_VARIATION_PASSWORD;
      TVirtualKeyboardType.URL:                   LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_VARIATION_PASSWORD;
      TVirtualKeyboardType.NamePhonePad:          LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_VARIATION_PASSWORD;
      TVirtualKeyboardType.EmailAddress:          LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_VARIATION_PASSWORD;
      else {TVirtualKeyboardType.Default}         LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_VARIATION_PASSWORD;
    end;
  end
  else if not aCheckSpelling then begin
    // https://stackoverflow.com/questions/61704644/why-type-text-flag-no-suggestions-is-not-working-to-disable-auto-corrections
    case aKeyboardType of
      TVirtualKeyboardType.Alphabet:              LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD;
      TVirtualKeyboardType.URL:;
      TVirtualKeyboardType.NamePhonePad:          LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_FLAG_NO_SUGGESTIONS or TJInputType.JavaClass.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD;
      TVirtualKeyboardType.EmailAddress:;
      TVirtualKeyboardType.NumbersAndPunctuation:;
      TVirtualKeyboardType.NumberPad:;
      TVirtualKeyboardType.PhonePad:;
      else {TVirtualKeyboardType.Default}         LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_FLAG_NO_SUGGESTIONS or TJInputType.JavaClass.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD;
    end;
  end;

  if aIsMultiline then LInputType := LInputType or TJInputType.JavaClass.TYPE_TEXT_FLAG_MULTI_LINE;

  NativeView.view.setInputType(LInputType);

end;

{**************************************************************************}
function TALAndroidEditControl.GetKeyboardType: TVirtualKeyboardType;
begin
  Result := fKeyboardType;
end;

{**************************************************************************}
procedure TALAndroidEditControl.setKeyboardType(const Value: TVirtualKeyboardType);
begin
  if (value <> fKeyboardType) then begin
    fKeyboardType := Value;
    DoSetInputType(Value, fAutoCapitalizationType, fPassword, fCheckSpelling, fIsMultiLine);
  end;
end;

{*********************************************************************************}
function TALAndroidEditControl.GetAutoCapitalizationType: TALAutoCapitalizationType;
begin
  result := fAutoCapitalizationType;
end;

{*****************************************************************************************}
procedure TALAndroidEditControl.setAutoCapitalizationType(const Value: TALAutoCapitalizationType);
begin
  if (value <> fAutoCapitalizationType) then begin
    fAutoCapitalizationType := Value;
    DoSetInputType(fKeyboardType, Value, fPassword, fCheckSpelling, fIsMultiLine);
  end;
end;

{**************************************************}
function TALAndroidEditControl.GetPassword: Boolean;
begin
  Result := fPassword;
end;

{*********************************************************}
procedure TALAndroidEditControl.setPassword(const Value: Boolean);
begin
  if (value <> fPassword) then begin
    fPassword := Value;
    DoSetInputType(fKeyboardType, fAutoCapitalizationType, Value, fCheckSpelling, fIsMultiLine);
  end;
end;

{*******************************************************}
function TALAndroidEditControl.GetCheckSpelling: Boolean;
begin
  result := fCheckSpelling;
end;

{**************************************************************}
procedure TALAndroidEditControl.SetCheckSpelling(const Value: Boolean);
begin
  if (value <> fCheckSpelling) then begin
    fCheckSpelling := Value;
    DoSetInputType(fKeyboardType, fAutoCapitalizationType, fPassword, Value, fIsMultiLine);
  end;
end;

{********************************************************************************}
procedure TALAndroidEditControl.DoSetReturnKeyType(const aReturnKeyType: TReturnKeyType);
begin
  var LImeOptions: integer;
  case aReturnKeyType of
    TReturnKeyType.Done:          LImeOptions := TJEditorInfo.JavaClass.IME_ACTION_DONE;
    TReturnKeyType.Go:            LImeOptions := TJEditorInfo.JavaClass.IME_ACTION_NONE; // TJEditorInfo.JavaClass.IME_ACTION_GO; => https://stackoverflow.com/questions/44708338/setimeactionlabel-or-setimeoptions-not-work-i-always-have-caption-done-on-the
    TReturnKeyType.Next:          LImeOptions := TJEditorInfo.JavaClass.IME_ACTION_NONE; // TJEditorInfo.JavaClass.IME_ACTION_NEXT; => https://stackoverflow.com/questions/44708338/setimeactionlabel-or-setimeoptions-not-work-i-always-have-caption-done-on-the
    TReturnKeyType.Search:        LImeOptions := TJEditorInfo.JavaClass.IME_ACTION_NONE; // TJEditorInfo.JavaClass.IME_ACTION_SEARCH; => https://stackoverflow.com/questions/44708338/setimeactionlabel-or-setimeoptions-not-work-i-always-have-caption-done-on-the
    TReturnKeyType.Send:          LImeOptions := TJEditorInfo.JavaClass.IME_ACTION_NONE; // TJEditorInfo.JavaClass.IME_ACTION_SEND; => https://stackoverflow.com/questions/44708338/setimeactionlabel-or-setimeoptions-not-work-i-always-have-caption-done-on-the
    else {TReturnKeyType.Default} LImeOptions := TJEditorInfo.JavaClass.IME_ACTION_NONE;
  end;
  NativeView.view.setImeOptions(LImeOptions);
end;

{**************************************************************}
function TALAndroidEditControl.GetReturnKeyType: TReturnKeyType;
begin
  Result := fReturnKeyType;
end;

{*********************************************************************}
procedure TALAndroidEditControl.setReturnKeyType(const Value: TReturnKeyType);
begin
  if (value <> fReturnKeyType) then begin
    fReturnKeyType := Value;
    DoSetReturnKeyType(Value);
  end;
end;

{***************************************************}
function TALAndroidEditControl.GetMaxLength: integer;
begin
  Result := FMaxLength;
end;

{**********************************************************}
procedure TALAndroidEditControl.SetMaxLength(const Value: integer);
begin
  if value <> FMaxLength then begin
    FMaxLength := value;
    NativeView.View.setMaxLength(Value);
  end;
end;

{********************************************}
function TALAndroidEditControl.GetPromptText: String;
begin
  result := JCharSequenceToStr(NativeView.View.getHint);
end;

{**********************************************************}
procedure TALAndroidEditControl.setPromptText(const Value: String);
begin
  NativeView.View.setHint(StrToJCharSequence(Value));
end;

{******************************************************}
function TALAndroidEditControl.GetPromptTextColor: TAlphaColor;
begin
  result := TAlphaColor(NativeView.View.getCurrentHintTextColor);
end;

{********************************************************************}
procedure TALAndroidEditControl.setPromptTextColor(const Value: TAlphaColor);
begin
  if Value <> TalphaColors.null then
    NativeView.View.setHintTextColor(integer(Value));
end;

{**************************************}
function TALAndroidEditControl.getText: String;
begin
  result := JCharSequenceToStr(NativeView.View.gettext);
end;

{****************************************************}
procedure TALAndroidEditControl.SetText(const Value: String);
begin
  NativeView.View.setText(StrToJCharSequence(Value), TJTextView_BufferType.javaClass.EDITABLE);
end;

{************************************************************}
procedure TALAndroidEditControl.TextSettingsChanged(Sender: TObject);
begin

  var LFontColor := integer(textsettings.font.color);
  var LFontSize: single := textsettings.font.size;

  var LFontStyles: TFontStyles := [];
  if textsettings.font.Weight in [TFontWeight.Bold,
                                  TFontWeight.UltraBold,
                                  TFontWeight.Black,
                                  TFontWeight.UltraBlack] then LFontStyles := LFontStyles + [TFontStyle.fsBold];
  if textsettings.font.Slant in [TFontSlant.Italic, TFontSlant.Oblique] then LFontStyles := LFontStyles + [TFontStyle.fsItalic];
  var LFontFamily := ALExtractPrimaryFontFamily(textsettings.font.Family);
  //-----
  //top	              0x30	     	Push object to the top of its container, not changing its size.
  //bottom	          0x50	     	Push object to the bottom of its container, not changing its size.
  //left	            0x03	     	Push object to the left of its container, not changing its size.
  //right            	0x05      	Push object to the right of its container, not changing its size.
  //center_vertical	  0x10      	Place object in the vertical center of its container, not changing its size.
  //fill_vertical	    0x70      	Grow the vertical size of the object if needed so it completely fills its container.
  //center_horizontal	0x01	     	Place object in the horizontal center of its container, not changing its size.
  //fill_horizontal	  0x07      	Grow the horizontal size of the object if needed so it completely fills its container.
  //center	          0x11	     	Place the object in the center of its container in both the vertical and horizontal axis, not changing its size.
  //fill	            0x77	     	Grow the horizontal and vertical size of the object if needed so it completely fills its container.
  //clip_vertical	    0x80	     	Additional option that can be set to have the top and/or bottom edges of the child clipped to its container's bounds. The clip will be based on the vertical gravity: a top gravity will clip the bottom edge, a bottom gravity will clip the top edge, and neither will clip both edges.
  //clip_horizontal	  0x08       	Additional option that can be set to have the left and/or right edges of the child clipped to its container's bounds. The clip will be based on the horizontal gravity: a left gravity will clip the right edge, a right gravity will clip the left edge, and neither will clip both edges.
  //start	            0x00800003	Push object to the beginning of its container, not changing its size.
  //end	              0x00800005	Push object to the end of its container, not changing its size.
  var LGravity: integer;
  case textsettings.HorzAlign of
    TALTextHorzAlign.Center: LGravity := $01; // center_horizontal 0x01
    TALTextHorzAlign.Leading: LGravity := $03; // left 0x03
    TALTextHorzAlign.Trailing: LGravity := $05; // right 0x05
    else LGravity := $03; // left 0x03
  end;
  case textsettings.VertAlign of
    TALTextVertAlign.Center: LGravity := LGravity or $10; // center_vertical 0x10
    TALTextVertAlign.Leading: LGravity := LGravity or $30; // top 0x30
    TALTextVertAlign.Trailing: LGravity := LGravity or $50; // bottom 0x50
    else LGravity := LGravity or $10; // center_vertical 0x10
  end;

  //-----
  NativeView.view.setTextColor(LFontColor); // Sets the text color for all the states (normal, selected, focused) to be this color.
  NativeView.view.setTextSize(TJTypedValue.javaclass.COMPLEX_UNIT_DIP, LFontSize); // Set the default text size to a given unit and value.
  //-----
  var LTypeface := TJTypeface.JavaClass.create(StringToJString(LFontFamily), ALfontStyleToAndroidStyle(LFontStyles));
  // Note that not all Typeface families actually have bold and italic variants, so you may
  // need to use setTypeface(Typeface, int) to get the appearance that you actually want.
  NativeView.view.setTypeface(LTypeface);
  LTypeface := nil;
  NativeView.view.setgravity(LGravity);
  //-----
  if not SameValue(textsettings.LineHeightMultiplier, 0, TEpsilon.Scale) then
    NativeView.view.setLineSpacing(0{add}, textsettings.LineHeightMultiplier{mult});

end;

{*******************************************************************}
function TALAndroidEditControl.GetTintColor: TAlphaColor;
begin
  Result := FTintColor;
end;

{*******************************************************************}
procedure TALAndroidEditControl.setTintColor(const Value: TAlphaColor);
begin
  FTintColor := Value;
end;

{*******************************************************************}
function TALAndroidEditControl.GetFillColor: TAlphaColor;
begin
  Result := FFillColor;
end;

{*******************************************************************}
procedure TALAndroidEditControl.SetFillColor(const Value: TAlphaColor);
begin
  FFillColor := Value;
end;

{*****************************************************************************************}
procedure TALAndroidEditControl.ApplicationEventHandler(const Sender: TObject; const M: TMessage);
begin
  {$IF defined(DEBUG)}
  if isfocused and
     (M is TApplicationEventMessage) then begin
    case (M as TApplicationEventMessage).Value.Event of
      TApplicationEvent.FinishedLaunching: ALLog('TALAndroidEditControl.ApplicationEventHandler', 'Event: TApplicationEvent.FinishedLaunching', TalLogType.VERBOSE);
      TApplicationEvent.BecameActive: ALLog('TALAndroidEditControl.ApplicationEventHandler', 'Event: TApplicationEvent.BecameActive', TalLogType.VERBOSE);
      TApplicationEvent.WillBecomeInactive: ALLog('TALAndroidEditControl.ApplicationEventHandler', 'Event: TApplicationEvent.WillBecomeInactive', TalLogType.VERBOSE);
      TApplicationEvent.EnteredBackground: ALLog('TALAndroidEditControl.ApplicationEventHandler', 'Event: TApplicationEvent.EnteredBackground', TalLogType.VERBOSE);
      TApplicationEvent.WillBecomeForeground: ALLog('TALAndroidEditControl.ApplicationEventHandler', 'Event: TApplicationEvent.WillBecomeForeground', TalLogType.VERBOSE);
      TApplicationEvent.WillTerminate: ALLog('TALAndroidEditControl.ApplicationEventHandler', 'Event: TApplicationEvent.WillTerminate', TalLogType.VERBOSE);
      TApplicationEvent.LowMemory: ALLog('TALAndroidEditControl.ApplicationEventHandler', 'Event: TApplicationEvent.LowMemory', TalLogType.VERBOSE);
      TApplicationEvent.TimeChange: ALLog('TALAndroidEditControl.ApplicationEventHandler', 'Event: TApplicationEvent.TimeChange', TalLogType.VERBOSE);
      TApplicationEvent.OpenURL: ALLog('TALAndroidEditControl.ApplicationEventHandler', 'Event: TApplicationEvent.OpenURL', TalLogType.VERBOSE);
    end;
  end;
  {$ENDIF}
  //problem is that as we play with view, the WillBecomeInactive - BecameActive will be call everytime we toggle the
  //view under the MainActivity.getViewStack. so we can't use these event to know that the application resume from
  //background. most easy is to close the virtual keyboard when the application entere in background (EnteredBackground
  //event is call ONLY when application entered in the background so everything is fine
  if isfocused and
     (M is TApplicationEventMessage) and
     ((M as TApplicationEventMessage).Value.Event = TApplicationEvent.EnteredBackground) then resetfocus;
end;

{********************************************}
function TALAndroidEditControl.getLineHeight: Single;
begin
  result := NativeView.view.getLineHeight / ALGetScreenScale;
end;

{$endif}
{$ENDREGION}

{$REGION ' IOS'}
{$IF defined(ios)}

{*********************************}
constructor TALIosEditTextField.Create;
begin
  inherited;
  View.setExclusiveTouch(True);
  View.setBorderStyle(UITextBorderStyleNone);
  View.addTarget(GetObjectID, sel_getUid(MarshaledAString(TMarshal.AsAnsi('ControlEventEditingChanged'))), UIControlEventEditingChanged);
end;

{***********************************************************}
constructor TALIosEditTextField.Create(const AControl: TControl);
begin
  fEditControl := TALIosEditControl(AControl);
  inherited;
end;

{*********************************}
destructor TALIosEditTextField.Destroy;
begin
  View.removeTarget(GetObjectID, sel_getUid(MarshaledAString(TMarshal.AsAnsi('ControlEventEditingChanged'))), UIControlEventEditingChanged);
  inherited;
end;

{*****************************************************************}
procedure TALIosEditTextField.SetEnabled(const value: Boolean);
begin
  inherited;
  View.SetEnabled(value);
end;

{***************************************************************************}
function TALIosEditTextField.ExtractFirstTouchPoint(touches: NSSet): TPointF;
begin
  var LPointer := touches.anyObject;
  if LPointer=nil then
    raise Exception.Create('Error 46450539-F150-45FC-BA01-0397F2A98B0C');
  var LLocalTouch := TUITouch.Wrap(LPointer);
  if Form=nil then
    raise Exception.Create('Error 5F61EC6E-0C13-46CD-A0C0-8417AA32B62A');
  var LTouchPoint := LLocalTouch.locationInView(GetFormView(Form));
  Result := TPointF.Create(LTouchPoint.X, LTouchPoint.Y);
end;

{*****************************************************************************}
procedure TALIosEditTextField.touchesBegan(touches: NSSet; withEvent: UIEvent);
begin
  if (Form <> nil) and
     (not view.isFirstResponder) and
     (touches.count > 0) then begin
    var LTouchPoint := ExtractFirstTouchPoint(touches);
    Form.MouseMove([ssTouch], LTouchPoint.X, LTouchPoint.Y);
    Form.MouseMove([], LTouchPoint.X, LTouchPoint.Y); // Require for correct IsMouseOver handle
    Form.MouseDown(TMouseButton.mbLeft, [ssLeft, ssTouch], LTouchPoint.x, LTouchPoint.y);
  end;
end;

{*********************************************************************************}
procedure TALIosEditTextField.touchesCancelled(touches: NSSet; withEvent: UIEvent);
begin
  if (Form <> nil) and
     (not view.isFirstResponder) and
     (touches.count > 0) then begin
    var LTouchPoint := ExtractFirstTouchPoint(touches);
    Form.MouseUp(TMouseButton.mbLeft, [ssLeft, ssTouch], LTouchPoint.x, LTouchPoint.y);
    Form.MouseLeave;
  end;
end;

{*****************************************************************************}
procedure TALIosEditTextField.touchesEnded(touches: NSSet; withEvent: UIEvent);
begin
  if (Form <> nil) and
     (not view.isFirstResponder) and
     (touches.count > 0) then begin
    var LTouchPoint := ExtractFirstTouchPoint(touches);
    Form.MouseUp(TMouseButton.mbLeft, [ssLeft, ssTouch], LTouchPoint.x, LTouchPoint.y);
    Form.MouseLeave;
  end;
end;

{*****************************************************************************}
procedure TALIosEditTextField.touchesMoved(touches: NSSet; withEvent: UIEvent);
begin
  if (Form <> nil) and
     (not view.isFirstResponder) and
     (touches.count > 0) then begin
    var LTouchPoint := ExtractFirstTouchPoint(touches);
    Form.MouseMove([ssLeft, ssTouch], LTouchPoint.x, LTouchPoint.y);
  end;
end;

{********************************************************}
function TALIosEditTextField.canBecomeFirstResponder: Boolean;
begin
  Result := UITextField(Super).canBecomeFirstResponder and TControl(fEditControl.Owner).canFocus;
end;

{*****************************************************}
function TALIosEditTextField.becomeFirstResponder: Boolean;
begin
  {$IF defined(DEBUG)}
  ALLog('TALIosEditTextField.becomeFirstResponder', 'control.name: ' + fEditControl.parent.Name, TalLogType.VERBOSE);
  {$ENDIF}
  if (not TControl(fEditControl.Owner).IsFocused) then
    TControl(fEditControl.Owner).SetFocus;
  Result := UITextField(Super).becomeFirstResponder;
end;

{***************************************************}
procedure TALIosEditTextField.ControlEventEditingChanged;
begin
  {$IF defined(DEBUG)}
  ALLog('TALIosEditTextField.ControlEventEditingChanged', 'control.name: ' + fEditControl.parent.Name, TalLogType.VERBOSE);
  {$ENDIF}
  fEditControl.DoChangeTracking;
end;

{*****************************************************}
function TALIosEditTextField.GetObjectiveCClass: PTypeInfo;
begin
  Result := TypeInfo(IALIosEditTextField);
end;

{********************************************}
function TALIosEditTextField.GetView: UITextField;
begin
  Result := inherited GetView<UITextField>;
end;

{****************************************************************************}
constructor TALIosEditTextFieldDelegate.Create(const AEditControl: TALIosEditControl);
begin
  inherited Create;
  FEditControl := AEditControl;
  if FEditControl = nil then
    raise EArgumentNilException.Create(Format(SWrongParameter, ['AEditControl']));
end;

{***********************************************************************************************************************************************}
function TALIosEditTextFieldDelegate.textField(textField: UITextField; shouldChangeCharactersInRange: NSRange; replacementString: NSString): Boolean;
begin
  {$IF defined(DEBUG)}
  ALLog(
    'TALIosEditTextFieldDelegate.textField',
    'control.name: ' + FEditControl.parent.Name + ' | ' +
    'replacementString: ' + NSStrToStr(replacementString),
    TalLogType.VERBOSE);
  {$ENDIF}
  if FEditControl.maxLength > 0 then begin
    var LText: NSString := TNSString.Wrap(textField.text);
    if shouldChangeCharactersInRange.length + shouldChangeCharactersInRange.location > LText.length then exit(false);
    result := LText.length + replacementString.length - shouldChangeCharactersInRange.length <= NSUInteger(FEditControl.maxLength);
  end
  else Result := True;
end;

{*********************************************************************************}
procedure TALIosEditTextFieldDelegate.textFieldDidBeginEditing(textField: UITextField);
begin
end;

{*******************************************************************************}
procedure TALIosEditTextFieldDelegate.textFieldDidEndEditing(textField: UITextField);
begin
  TControl(FEditControl.Owner).ResetFocus;
end;

{********************************************************************************************}
function TALIosEditTextFieldDelegate.textFieldShouldBeginEditing(textField: UITextField): Boolean;
begin
  Result := True;
end;

{*************************************************************************************}
function TALIosEditTextFieldDelegate.textFieldShouldClear(textField: UITextField): Boolean;
begin
  Result := true;
end;

{******************************************************************************************}
function TALIosEditTextFieldDelegate.textFieldShouldEndEditing(textField: UITextField): Boolean;
begin
  Result := True;
end;

{**************************************************************************************}
function TALIosEditTextFieldDelegate.textFieldShouldReturn(textField: UITextField): Boolean;
begin
  {$IF defined(DEBUG)}
  ALLog('TALIosEditTextFieldDelegate.textFieldShouldReturn', 'control.name: ' + FEditControl.parent.Name, TalLogType.VERBOSE);
  {$ENDIF}
  if assigned(fEditControl.OnReturnKey) then begin
    fEditControl.DoReturnKey;
    result := false;
  end
  else Result := true; // return YES if the text field should implement its default behavior for the return button; otherwise, NO.
end;

{************************************************}
constructor TALIosEditControl.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FTextFieldDelegate := TALIosEditTextFieldDelegate.Create(Self);
  NativeView.View.setDelegate(FTextFieldDelegate.GetObjectID);
  FFillColor := $ffffffff;
  fMaxLength := 0;
  fPromptTextColor := TalphaColors.Null;
  SetReturnKeyType(tReturnKeyType.Default);
  SetKeyboardType(TVirtualKeyboardType.default);
  setAutoCapitalizationType(TALAutoCapitalizationType.acNone);
  SetPassword(false);
  SetCheckSpelling(True);
end;

{***********************************}
destructor TALIosEditControl.Destroy;
begin
  NativeView.View.setDelegate(nil);
  ALFreeAndNil(FTextFieldDelegate);
  inherited Destroy;
end;

{********************************************************************}
Function TALIosEditControl.CreateNativeView: TALIosNativeView;
begin
  result := TALIosEditTextField.create(self);
end;

{********************************************************}
function TALIosEditControl.GetNativeView: TALIosEditTextField;
begin
  result := TALIosEditTextField(inherited GetNativeView);
end;

{**********************************************************************}
procedure TALIosEditControl.SetKeyboardType(const Value: TVirtualKeyboardType);
begin
  var LUIKeyboardType: UIKeyboardType;
  case Value of
    TVirtualKeyboardType.NumbersAndPunctuation: LUIKeyboardType := UIKeyboardTypeNumbersAndPunctuation;
    TVirtualKeyboardType.NumberPad:             LUIKeyboardType := UIKeyboardTypeNumberPad;
    TVirtualKeyboardType.PhonePad:              LUIKeyboardType := UIKeyboardTypePhonePad;
    TVirtualKeyboardType.Alphabet:              LUIKeyboardType := UIKeyboardTypeDefault;
    TVirtualKeyboardType.URL:                   LUIKeyboardType := UIKeyboardTypeURL;
    TVirtualKeyboardType.NamePhonePad:          LUIKeyboardType := UIKeyboardTypeNamePhonePad;
    TVirtualKeyboardType.EmailAddress:          LUIKeyboardType := UIKeyboardTypeEmailAddress;
    else {TVirtualKeyboardType.Default}         LUIKeyboardType := UIKeyboardTypeDefault;
  end;
  NativeView.View.setKeyboardType(LUIKeyboardType);
end;

{********************************************************}
function TALIosEditControl.GetKeyboardType: TVirtualKeyboardType;
begin
  var LUIKeyboardType := NativeView.View.KeyboardType;
  case LUIKeyboardType of
    UIKeyboardTypeNumbersAndPunctuation: result := TVirtualKeyboardType.NumbersAndPunctuation;
    UIKeyboardTypeNumberPad:             result := TVirtualKeyboardType.NumberPad;
    UIKeyboardTypePhonePad:              result := TVirtualKeyboardType.PhonePad;
    UIKeyboardTypeURL:                   result := TVirtualKeyboardType.URL;
    UIKeyboardTypeNamePhonePad:          result := TVirtualKeyboardType.NamePhonePad;
    UIKeyboardTypeEmailAddress:          result := TVirtualKeyboardType.EmailAddress;
    else                                 result := TVirtualKeyboardType.Default;
  end;
end;

{*************************************************************************************}
procedure TALIosEditControl.setAutoCapitalizationType(const Value: TALAutoCapitalizationType);
begin
  var LUITextAutoCapitalizationType: UITextAutoCapitalizationType;
  case Value of
    TALAutoCapitalizationType.acWords:          LUITextAutoCapitalizationType := UITextAutoCapitalizationTypeWords;
    TALAutoCapitalizationType.acSentences:      LUITextAutoCapitalizationType := UITextAutoCapitalizationTypeSentences;
    TALAutoCapitalizationType.acAllCharacters:  LUITextAutoCapitalizationType := UITextAutoCapitalizationTypeAllCharacters;
    else {TALAutoCapitalizationType.acNone}     LUITextAutoCapitalizationType := UITextAutoCapitalizationTypeNone;
  end;
  NativeView.View.setAutoCapitalizationType(LUITextAutoCapitalizationType);
end;

{***********************************************************************}
function TALIosEditControl.GetAutoCapitalizationType: TALAutoCapitalizationType;
begin
  var LUITextAutoCapitalizationType := NativeView.View.AutoCapitalizationType;
  case LUITextAutoCapitalizationType of
    UITextAutoCapitalizationTypeWords:         result := TALAutoCapitalizationType.acWords;
    UITextAutoCapitalizationTypeSentences:     result := TALAutoCapitalizationType.acSentences;
    UITextAutoCapitalizationTypeAllCharacters: result := TALAutoCapitalizationType.acAllCharacters;
    else                                       result := TALAutoCapitalizationType.acNone;
  end;
end;

{*****************************************************}
procedure TALIosEditControl.SetPassword(const Value: Boolean);
begin
  NativeView.View.setSecureTextEntry(Value);
end;

{***************************************}
function TALIosEditControl.GetPassword: Boolean;
begin
  result := NativeView.View.isSecureTextEntry;
end;

{**********************************************************}
procedure TALIosEditControl.SetCheckSpelling(const Value: Boolean);
begin
  if Value then begin
    NativeView.View.setSpellCheckingType(UITextSpellCheckingTypeYes);
    NativeView.View.setAutocorrectionType(UITextAutocorrectionTypeDefault);
  end
  else begin
    NativeView.View.setSpellCheckingType(UITextSpellCheckingTypeNo);
    NativeView.View.setAutocorrectionType(UITextAutocorrectionTypeNo);
  end;
end;

{********************************************}
function TALIosEditControl.GetCheckSpelling: Boolean;
begin
  result := NativeView.View.SpellCheckingType = UITextSpellCheckingTypeYes;
end;

{*****************************************************************}
procedure TALIosEditControl.setReturnKeyType(const Value: TReturnKeyType);
begin
  var LUIReturnKeyType: UIReturnKeyType;
  case Value of
    TReturnKeyType.Done:           LUIReturnKeyType := UIReturnKeyDone;
    TReturnKeyType.Go:             LUIReturnKeyType := UIReturnKeyGo;
    TReturnKeyType.Next:           LUIReturnKeyType := UIReturnKeyNext;
    TReturnKeyType.Search:         LUIReturnKeyType := UIReturnKeySearch;
    TReturnKeyType.Send:           LUIReturnKeyType := UIReturnKeySend;
    else {TReturnKeyType.Default}  LUIReturnKeyType := UIReturnKeyDefault;
  end;
  NativeView.View.setReturnKeyType(LUIReturnKeyType);
end;

{***************************************************}
function TALIosEditControl.GetReturnKeyType: TReturnKeyType;
begin
  var LUIReturnKeyType := NativeView.View.ReturnKeyType;
  case LUIReturnKeyType of
    UIReturnKeyDone:    result := TReturnKeyType.Done;
    UIReturnKeyGo:      result := TReturnKeyType.Go;
    UIReturnKeyNext:    result := TReturnKeyType.Next;
    UIReturnKeySearch:  result := TReturnKeyType.Search;
    UIReturnKeySend:    result := TReturnKeyType.Send;
    else                result := TReturnKeyType.Default;
  end;
end;

{****************************************}
function TALIosEditControl.GetPromptText: String;
begin
  var LAttributedString := NativeView.View.AttributedPlaceholder;
  if LAttributedString = nil then Result := NSStrToStr(NativeView.View.placeholder)
  else result := NSStrToStr(LAttributedString.&String);
end;

{******************************************************}
procedure TALIosEditControl.setPromptText(const Value: String);
begin
  applyPromptTextWithColor(Value, fPromptTextColor);
end;

{****************************************************************}
function TALIosEditControl.GetPromptTextColor: TAlphaColor;
begin
  Result := fPromptTextColor;
end;

{****************************************************************}
procedure TALIosEditControl.setPromptTextColor(const Value: TAlphaColor);
begin
  if Value <> fPromptTextColor then begin
    fPromptTextColor := Value;
    applyPromptTextWithColor(GetPromptText, fPromptTextColor);
  end;
end;

{*******************************************************************************************}
procedure TALIosEditControl.applyPromptTextWithColor(const aStr: String; const aColor: TAlphaColor);
begin
  //Using `setPlaceholderString` is not suitable here because it does not allow customizing the placeholder text color,
  //which depends on the OS's light or dark mode. However, this application requires a placeholder color that is
  //independent of the system theme, as the background color does not adapt to the dark or light mode settings.
  //if (aColor = tAlphaColors.Null) or aStr.IsEmpty then FTextField.View.setPlaceholder(StrToNSStr(aStr))
  //else begin

  var LPromptTextAttr: NSMutableAttributedString := TNSMutableAttributedString.Wrap(TNSMutableAttributedString.Alloc.initWithString(StrToNSStr(aStr)));
  try

    if not aStr.IsEmpty then begin
      LPromptTextAttr.beginEditing;
      try
        var LTextRange := NSMakeRange(0, aStr.Length);
        var LUIColor: UIColor;
        if aColor <> tAlphaColors.Null then LUIColor := AlphaColorToUIColor(aColor)
        else LUIColor := AlphaColorToUIColor(
                           TAlphaColorF.Create(
                             ALSetColorOpacity(TextSettings.Font.Color, 0.5)).
                               PremultipliedAlpha.
                               ToAlphaColor);
        LPromptTextAttr.addAttribute(NSForegroundColorAttributeName, NSObjectToID(LUIColor), LTextRange);
        //NOTE: If I try to release the LUIColor I have an exception
      finally
        LPromptTextAttr.endEditing;
      end;
    end;

    NativeView.View.setAttributedPlaceholder(LPromptTextAttr);

  finally
    LPromptTextAttr.release;
  end;
end;

{********************************************}
function TALIosEditControl.GetTintColor: TAlphaColor;
begin
  var red: CGFloat;
  var green: CGFloat;
  var blue: CGFloat;
  var alpha: CGFloat;
  if not NativeView.View.tintColor.getRed(@red, @green, @blue, @alpha) then result := TalphaColors.Null
  else result := TAlphaColorF.Create(red, green, blue, alpha).ToAlphaColor;
end;

{**********************************************************}
procedure TALIosEditControl.setTintColor(const Value: TAlphaColor);
begin
  if Value <> TalphaColors.Null then
    NativeView.View.setTintColor(AlphaColorToUIColor(Value));
end;

{**********************************}
function TALIosEditControl.getText: String;
begin
  result := NSStrToStr(TNSString.Wrap(NativeView.View.text));
end;

{************************************************}
procedure TALIosEditControl.SetText(const Value: String);
begin
  NativeView.View.setText(StrToNSStr(Value));
end;

{***********************************************}
function TALIosEditControl.GetMaxLength: integer;
begin
  Result := FMaxLength;
end;

{*************************************************************}
procedure TALIosEditControl.SetMaxLength(const Value: integer);
begin
  FMaxLength := Value;
end;

{********************************************************}
procedure TALIosEditControl.TextSettingsChanged(Sender: TObject);
begin
  // Font
  var LFontRef := ALCreateCTFontRef(TextSettings.Font.Family, TextSettings.Font.Size, TextSettings.Font.Weight, TextSettings.Font.Slant);
  try
    var LDictionary := TNSDictionary.Wrap(
                         TNSDictionary.OCClass.dictionaryWithObject(
                           LFontRef,
                           NSObjectToID(TNSString.Wrap(kCTFontAttributeName))));
    // Setting this property applies the specified attributes to the entire
    // text of the text field. Unset attributes maintain their default values.
    // Note: I can't later call LDictionary.release or I have an error
    NativeView.View.setdefaultTextAttributes(LDictionary);
  finally
    CFRelease(LFontRef);
  end;

  // TextAlignment
  NativeView.View.setTextAlignment(ALTextHorzAlignToUITextAlignment(TextSettings.HorzAlign));

  // TextColor
  NativeView.View.setTextColor(AlphaColorToUIColor(TextSettings.Font.Color));
end;

{***************************************************************}
function TALIosEditControl.GetFillColor: TAlphaColor;
begin
  Result := FFillColor;
end;

{***************************************************************}
procedure TALIosEditControl.SetFillColor(const Value: TAlphaColor);
begin
  FFillColor := Value;
end;

{****************************************}
function TALIosEditControl.getLineHeight: Single;
begin
  if NativeView.View.font = nil then
    TextSettingsChanged(nil);
  result := NativeView.View.font.lineHeight;
  if not SameValue(textsettings.LineHeightMultiplier, 0, TEpsilon.Scale) then
    result := result * textsettings.LineHeightMultiplier;
end;

{$endif}
{$ENDREGION}

{$REGION ' MacOS'}
{$IF defined(ALMacOS)}

{*********************************}
constructor TALMacEditTextField.Create;
begin
  inherited;
  View.SetBezeled(False);
  View.setBordered(false);
  View.setLineBreakMode(NSLineBreakByClipping);
  View.setDrawsBackground(false);
  View.setFocusRingType(NSFocusRingTypeNone);
end;

{***********************************************************}
constructor TALMacEditTextField.Create(const AControl: TControl);
begin
  fEditControl := TalMacEditControl(AControl);
  inherited;
end;

{*********************************************************}
procedure TALMacEditTextField.SetEnabled(const value: Boolean);
begin
  inherited;
  View.SetEnabled(value);
end;

{******************************************************}
function TALMacEditTextField.acceptsFirstResponder: Boolean;
begin
  Result := NSTextField(Super).acceptsFirstResponder and TControl(fEditControl.Owner).canFocus;
end;

{*****************************************************}
function TALMacEditTextField.becomeFirstResponder: Boolean;
begin
  {$IF defined(DEBUG)}
  ALLog('TALMacEditTextField.becomeFirstResponder', 'control.name: ' + fEditControl.parent.Name, TalLogType.VERBOSE);
  {$ENDIF}
  if (not TControl(fEditControl.Owner).IsFocused) then
    TControl(fEditControl.Owner).SetFocus;
  Result := NSTextField(Super).becomeFirstResponder;
end;

{*****************************************************}
function TALMacEditTextField.GetObjectiveCClass: PTypeInfo;
begin
  Result := TypeInfo(IALMacEditTextField);
end;

{********************************************}
function TALMacEditTextField.GetView: NSTextField;
begin
  Result := inherited GetView<NSTextField>;
end;

{****************************************************************************}
constructor TALMacEditTextFieldDelegate.Create(const AEditControl: TALMacEditControl);
begin
  inherited Create;
  FEditControl := AEditControl;
  if FEditControl = nil then
    raise EArgumentNilException.Create(Format(SWrongParameter, ['AEditControl']));
end;

{********************************************************************************}
procedure TALMacEditTextFieldDelegate.controlTextDidBeginEditing(obj: NSNotification);
begin
end;

{******************************************************************************}
procedure TALMacEditTextFieldDelegate.controlTextDidEndEditing(obj: NSNotification);
begin
  TControl(FEditControl.Owner).ResetFocus;
end;

{**************************************************************************}
procedure TALMacEditTextFieldDelegate.controlTextDidChange(obj: NSNotification);
begin
  if FEditControl.maxLength > 0 then begin
    var LText := NSStrToStr(FEditControl.NativeView.View.stringValue);
    if LText.length > FEditControl.maxLength then begin
      FEditControl.NativeView.View.SetStringValue(StrToNSStr(ALCopyStr(LText,1,FEditControl.maxLength)));
      exit;
    end;
  end;
  fEditControl.DoChangeTracking;
end;

{**************************************************************************************************************************}
function TALMacEditTextFieldDelegate.controlTextShouldBeginEditing(control: NSControl; textShouldBeginEditing: NSText): Boolean;
begin
  Result := True;
end;

{**********************************************************************************************************************}
function TALMacEditTextFieldDelegate.controlTextShouldEndEditing(control: NSControl; textShouldEndEditing: NSText): Boolean;
begin
  Result := True;
end;

{***********************************************************************************************************************************************}
function TALMacEditTextFieldDelegate.controlTextViewDoCommandBySelector(control: NSControl; textView: NSTextView; doCommandBySelector: SEL): Boolean;
begin
  if assigned(fEditControl.OnReturnKey) and (sel_getName(doCommandBySelector) = 'insertNewline:') then begin
    fEditControl.DoReturnKey;
    Result := True;
  end
  else
    result := False;
end;

{************************************************}
constructor TALMacEditControl.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FTextFieldDelegate := TALMacEditTextFieldDelegate.Create(Self);
  NativeView.View.setDelegate(FTextFieldDelegate.GetObjectID);
  FFillColor := $ffffffff;
  fMaxLength := 0;
  fReturnKeyType := tReturnKeyType.Default;
  fKeyboardType := TVirtualKeyboardType.default;
  fAutoCapitalizationType := TALAutoCapitalizationType.acNone;
  fPassword := false;
  fCheckSpelling := true;
  fPromptTextColor := TalphaColors.Null;
  FTintColor := TalphaColors.Null;
end;

{***********************************}
destructor TALMacEditControl.Destroy;
begin
  NativeView.View.setDelegate(nil);
  ALFreeAndNil(FTextFieldDelegate);
  inherited Destroy;
end;

{********************************************************************}
Function TALMacEditControl.CreateNativeView: TALMacNativeView;
begin
  result := TALMacEditTextField.create(self);
end;

{********************************************************}
function TALMacEditControl.GetNativeView: TALMacEditTextField;
begin
  result := TALMacEditTextField(inherited GetNativeView);
end;

{********************************************************}
function TALMacEditControl.GetKeyboardType: TVirtualKeyboardType;
begin
  Result := FKeyboardType;
end;

{********************************************************}
procedure TALMacEditControl.setKeyboardType(const Value: TVirtualKeyboardType);
begin
  FKeyboardType := Value;
end;

{********************************************************}
function TALMacEditControl.GetAutoCapitalizationType: TALAutoCapitalizationType;
begin
  Result := FAutoCapitalizationType;
end;

{********************************************************}
procedure TALMacEditControl.setAutoCapitalizationType(const Value: TALAutoCapitalizationType);
begin
  FAutoCapitalizationType := Value;
end;

{********************************************************}
function TALMacEditControl.GetPassword: Boolean;
begin
  Result := FPassword;
end;

{********************************************************}
procedure TALMacEditControl.setPassword(const Value: Boolean);
begin
  FPassword := Value;
end;

{********************************************************}
function TALMacEditControl.GetCheckSpelling: Boolean;
begin
  Result := FCheckSpelling;
end;

{********************************************************}
procedure TALMacEditControl.setCheckSpelling(const Value: Boolean);
begin
  FCheckSpelling := Value;
end;

{********************************************************}
function TALMacEditControl.GetReturnKeyType: TReturnKeyType;
begin
  Result := FReturnKeyType;
end;

{********************************************************}
procedure TALMacEditControl.setReturnKeyType(const Value: TReturnKeyType);
begin
  FReturnKeyType := Value;
end;

{****************************************}
function TALMacEditControl.GetPromptText: String;
begin
  var LAttributedString := NativeView.View.placeholderAttributedString;
  if LAttributedString = nil then Result := NSStrToStr(NativeView.View.PlaceholderString)
  else result := NSStrToStr(LAttributedString.&String);
end;

{******************************************************}
procedure TALMacEditControl.setPromptText(const Value: String);
begin
  applyPromptTextWithColor(Value, fPromptTextColor);
end;

{***************************************************************}
function TALMacEditControl.GetPromptTextColor: TAlphaColor;
begin
  result := fPromptTextColor;
end;

{****************************************************************}
procedure TALMacEditControl.setPromptTextColor(const Value: TAlphaColor);
begin
  if Value <> fPromptTextColor then begin
    fPromptTextColor := Value;
    applyPromptTextWithColor(GetPromptText, fPromptTextColor);
  end;
end;

{*******************************************************************************************}
procedure TALMacEditControl.applyPromptTextWithColor(const aStr: String; const aColor: TAlphaColor);
begin
  //Using `setPlaceholderString` is not suitable here because it does not allow customizing the placeholder text color,
  //which depends on the OS's light or dark mode. However, this application requires a placeholder color that is
  //independent of the system theme, as the background color does not adapt to the dark or light mode settings.
  //if (aColor = tAlphaColors.Null) or aStr.IsEmpty then FTextField.View.SetPlaceholderString(StrToNSStr(aStr))
  //else begin

  var LPromptTextAttr: NSMutableAttributedString := TNSMutableAttributedString.Wrap(TNSMutableAttributedString.Alloc.initWithString(StrToNSStr(aStr)));
  try

    if not aStr.IsEmpty then begin
      LPromptTextAttr.beginEditing;
      try
        var LTextRange := NSMakeRange(0, aStr.Length);
        var LNSColor: NSColor;
        if aColor <> tAlphaColors.Null then LNSColor := AlphaColorToNSColor(aColor)
        else LNSColor := AlphaColorToNSColor(
                           TAlphaColorF.Create(
                             ALSetColorOpacity(TextSettings.Font.Color, 0.5)).
                               PremultipliedAlpha.
                               ToAlphaColor);
        LPromptTextAttr.addAttribute(NSForegroundColorAttributeName, NSObjectToID(LNSColor), LTextRange);
        //NOTE: If I try to release the LNSColor I have an exception

        // No need to do this in iOS, only in MacOS
        var LParagraphStyle := TNSMutableParagraphStyle.Alloc;
        try
          LParagraphStyle.init;
          LParagraphStyle.setAlignment(ALTextHorzAlignToNSTextAlignment(TextSettings.HorzAlign));
          LPromptTextAttr.addAttribute(NSParagraphStyleAttributeName, NSObjectToID(LParagraphStyle), LTextRange);
        finally
          LParagraphStyle.release;
        end;

        // No need to do this in iOS, only in MacOS
        var LFontRef := ALCreateCTFontRef(TextSettings.Font.Family, TextSettings.Font.Size, TextSettings.Font.Weight, TextSettings.Font.Slant);
        try
          LPromptTextAttr.addAttribute(NSFontAttributeName, NSObjectToID(TNSFont.Wrap(LFontRef)), LTextRange);
        finally
          CFRelease(LFontRef);
        end;
      finally
        LPromptTextAttr.endEditing;
      end;
    end;

    NativeView.View.setPlaceholderAttributedString(LPromptTextAttr);

  finally
    LPromptTextAttr.release;
  end;
end;

{**********************************}
function TALMacEditControl.GetTintColor: TAlphaColor;
begin
  Result := FTintColor;
end;

{**********************************}
procedure TALMacEditControl.setTintColor(const Value: TAlphaColor);
begin
  FTintColor := Value;
end;

{**********************************}
function TALMacEditControl.GetFillColor: TAlphaColor;
begin
  Result := FFillColor;
end;

{**********************************}
procedure TALMacEditControl.SetFillColor(const Value: TAlphaColor);
begin
  FFillColor := Value;
end;

{**********************************}
function TALMacEditControl.getText: String;
begin
  result := NSStrToStr(NativeView.View.StringValue);
end;

{************************************************}
procedure TALMacEditControl.SetText(const Value: String);
begin
  NativeView.View.setStringValue(StrToNSStr(Value));
end;

{********************************************************}
procedure TALMacEditControl.TextSettingsChanged(Sender: TObject);
begin
  // Font
  var LFontRef := ALCreateCTFontRef(TextSettings.Font.Family, TextSettings.Font.Size, TextSettings.Font.Weight, TextSettings.Font.Slant);
  try
    NativeView.View.setFont(TNSFont.Wrap(LFontRef));
  finally
    CFRelease(LFontRef);
  end;

  // TextAlignment
  NativeView.View.setAlignment(ALTextHorzAlignToNSTextAlignment(TextSettings.HorzAlign));

  // TextColor
  NativeView.View.setTextColor(AlphaColorToNSColor(TextSettings.Font.Color));

  // Update the PromptText with the new font settings. This is only necessary in macOS.
  // In iOS, this step is not required.
  applyPromptTextWithColor(PromptText, PromptTextColor);
end;

{****************************************}
function TALMacEditControl.GetMaxLength: integer;
begin
  Result := FMaxLength;
end;

{****************************************}
procedure TALMacEditControl.SetMaxLength(const Value: integer);
begin
  FMaxLength := Value;
end;

{****************************************}
function TALMacEditControl.getLineHeight: Single;
begin
  var LfontMetrics := ALGetFontMetrics(
                        TextSettings.Font.Family, // const AFontFamily: String;
                        TextSettings.Font.Size, // const AFontSize: single;
                        TextSettings.Font.Weight, // const AFontWeight: TFontWeight;
                        TextSettings.Font.Slant, // const AFontSlant: TFontSlant;
                        TextSettings.Font.Color, // const AFontColor: TalphaColor;
                        TextSettings.Decoration.Kinds); // const ADecorationKinds: TALTextDecorationKinds;
  result := -LfontMetrics.Ascent + LfontMetrics.Descent + LfontMetrics.Leading;
  if not SameValue(textsettings.LineHeightMultiplier, 0, TEpsilon.Scale) then
    result := result * textsettings.LineHeightMultiplier;
end;

{$endif}
{$ENDREGION}

{$REGION ' MSWINDOWS'}
{$IF defined(MSWINDOWS)}

{***********************************************}
function InitCommonControl(CC: Integer): Boolean;
var
  ICC: TInitCommonControlsEx;
begin
  ICC.dwSize := SizeOf(TInitCommonControlsEx);
  ICC.dwICC := CC;
  Result := InitCommonControlsEx(ICC);
  if not Result then InitCommonControls;
end;

{****************************************}
procedure CheckCommonControl(CC: Integer);
begin
  if not InitCommonControl(CC) then
    raise EComponentError.Create('This control requires version 4.70 or greater of COMCTL32.DLL');
end;

{**********************************************************}
constructor TALWinEditView.Create(const AControl: TControl);
begin
  CheckCommonControl(ICC_STANDARD_CLASSES);
  FFontHandle := 0;
  FBackgroundBrush := 0;
  fEditControl := TALWinEditControl(AControl);
  inherited Create(AControl);
end;

{***************************************************************}
procedure TALWinEditView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'EDIT');
  Params.Style := Params.Style or ES_AUTOHSCROLL;
end;

{********************************}
destructor TALWinEditView.Destroy;
begin
  if (FFontHandle <> 0) and (not DeleteObject(FFontHandle)) then
    raise Exception.Create('Error 5E76956E-B13B-4694-8D83-CA6BEBC06CCE');
  if (FBackgroundBrush <> 0) and (not DeleteObject(FBackgroundBrush)) then
    RaiseLastOsError;
  inherited Destroy;
end;

{**********************}
{$IF not defined(ALDPK)}
procedure TALWinEditView.UpdateFontHandle;
begin
  SendMessage(Handle, WM_SETFONT, 0, 0);

  if FFontHandle <> 0 then begin
    if not DeleteObject(FFontHandle) then RaiseLastOsError;
    FFontHandle := 0;
  end;
  FFontHandle := CreateFont(
                   -Round(FEditControl.TextSettings.Font.Size * ALGetScreenScale), // nHeight
                   0, // nWidth
                   0, // nEscapement
                   0, // nOrientaion
                   FontWeightToWinapi(FEditControl.TextSettings.Font.Weight), // fnWeight
                   DWORD(not FEditControl.TextSettings.Font.Slant.IsRegular), // fdwItalic
                   DWORD(TALTextDecorationKind.Underline in FEditControl.TextSettings.Decoration.Kinds), // fdwUnderline
                   DWORD(TALTextDecorationKind.LineThrough in FEditControl.TextSettings.Decoration.Kinds), // fdwStrikeOut
                   0, // fdwCharSet
                   0, // fdwOutputPrecision
                   0, // fdwClipPrecision
                   0, // fdwQuality
                   0, // fdwPitchAndFamily
                   PChar(ALExtractPrimaryFontFamily(FEditControl.TextSettings.Font.Family))); // lpszFace

  SendMessage(Handle, WM_SETFONT, FFontHandle, 1);
end;
{$ENDIF}

{**********************}
{$IF not defined(ALDPK)}
procedure TALWinEditView.UpdateBackgroundBrush;
begin
  if (fBackgroundBrush <> 0) and (not DeleteObject(fBackgroundBrush)) then
    RaiseLastOsError;
  if FEditControl.FillColor <> TAlphaColors.Null then begin
    fBackgroundBrush := CreateSolidBrush(TAlphaColors.ColorToRGB(FEditControl.FillColor));
    if fBackgroundBrush = 0 then RaiseLastOsError;
  end
  else
    fBackgroundBrush := 0;
end;
{$ENDIF}

{**********************************************************}
procedure TALWinEditView.WMKeyDown(var Message: TWMKeyDown);
begin
  if Message.CharCode = VK_TAB then begin
    // Without this adjustment, pressing the Tab key results in a beep sound.
    // This occurs because the Windows API attempts to move focus to the next
    // control, but tab navigation is somehow restricted in the current context),
    // it signals this inability or failure by playing a system sound.
    var LMsg: TMsg;
    PeekMessage(LMsg, Handle, 0, 0, PM_REMOVE);
  end;
  inherited;
  if Message.CharCode = VK_RETURN then fEditControl.DoReturnKey
  else if Message.CharCode = VK_DELETE then fEditControl.DoChangeTracking;
end;

{******************************************************************}
procedure TALWinEditView.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  invalidate;
end;

{**************************************************************}
procedure TALWinEditView.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  invalidate;
end;

{**************************************************************}
procedure TALWinEditView.WMMouseMove(var Message: TWMMouseMove);
begin
  inherited;
  invalidate;
end;

{****************************************************}
procedure TALWinEditView.WMChar(var Message: TWMChar);
begin
  inherited;
  invalidate;
  fEditControl.DoChangeTracking;
end;

{**************************************************************************}
procedure TALWinEditView.WMTextColor(var Message: WinApi.Messages.TMessage);
begin
  inherited;
  if SetTextColor(Message.wParam, TAlphaColors.ColorToRGB(FeditControl.TextSettings.Font.Color)) = CLR_INVALID then RaiseLastOSError;
  if fBackgroundBrush <> 0 then begin
    if SetBkColor(Message.wParam, TAlphaColors.ColorToRGB(FEditControl.FillColor)) = CLR_INVALID then RaiseLastOSError;
    Message.Result := LRESULT(FBackgroundBrush);
  end
  else
    Message.Result := GetSysColorBrush(COLOR_WINDOW);
end;

{******************************************************}
procedure TALWinEditView.WMPaint(var Message: TWMPaint);
begin
  if (FEditControl.PromptText <> '') and
     (GetWindowTextLength(Handle) = 0) then begin
    var LPS: PAINTSTRUCT;
    var LDC := BeginPaint(Handle, LPS);
    if LDC = 0 then raise Exception.Create('Error 3B053C24-4A18-497C-82B1-C540EF7C2A4B');
    Try
      var LPromptTextColor := FeditControl.PromptTextColor;
      if LPromptTextColor = TAlphaColors.Null then
        LPromptTextColor := ALBlendColorWithOpacity(FEditControl.fillColor, FeditControl.TextSettings.Font.Color, 0.3);
      if SetTextColor(LDC, TAlphaColors.ColorToRGB(LPromptTextColor)) = CLR_INVALID then RaiseLastOSError;
      if SetBkColor(LDC, TAlphaColors.ColorToRGB(FeditControl.fillColor)) = CLR_INVALID then RaiseLastOSError;
      if FBackgroundBrush <> 0 then begin
        if FillRect(LDC, LPS.rcPaint, FBackgroundBrush) = 0 then raiseLastOsError;
      end
      else begin
        if FillRect(LDC, LPS.rcPaint, GetSysColorBrush(COLOR_WINDOW)) = 0 then raiseLastOsError;
      end;
      if SetBkMode(LDC, TRANSPARENT) = 0 then RaiseLastOSError;
      If (FFontHandle <> 0) and (SelectObject(LDC, FFontHandle) = 0) then raiseLastOsError;
      var LMargins := SendMessage(Handle, EM_GETMARGINS, 0, 0);
      //LOWORD(LMargins) = Left Margin
      //HIWORD(LMargins) = Right Margin
      case FeditControl.TextSettings.HorzAlign of
          TALTextHorzAlign.Center: begin
            var LTextSize: TSize;
            GetTextExtentPoint32(LDC, Pchar(FEditControl.PromptText), Length(FEditControl.PromptText), LTextSize);
            TextOut(LDC, round((FeditControl.Width - LtextSize.cx) / 2), 0, Pchar(FEditControl.PromptText), Length(FEditControl.PromptText));
          end;
          TALTextHorzAlign.Leading,
          TALTextHorzAlign.Justify:  begin
            TextOut(LDC, round(LOWORD(LMargins) * ALGetScreenScale), 0, Pchar(FEditControl.PromptText), Length(FEditControl.PromptText));
          end;
          TALTextHorzAlign.Trailing: begin
            var LTextSize: TSize;
            GetTextExtentPoint32(LDC, Pchar(FEditControl.PromptText), Length(FEditControl.PromptText), LTextSize);
            TextOut(LDC, round(FeditControl.Width - LtextSize.cx - HIWORD(LMargins)), 0, Pchar(FEditControl.PromptText), Length(FEditControl.PromptText));
          end;
        else raise Exception.Create('Error 21CC0DF5-9030-4F6C-9830-112E17E1A392');
      end;

    finally
      EndPaint(Handle, LPS);
    end;
  end
  else
    inherited;
end;

{************************************************}
constructor TALWinEditControl.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FFillColor := $ffffffff;
  FPromptText := '';
  FPromptTextColor := TalphaColors.Null;
  fReturnKeyType := tReturnKeyType.Default;
  fKeyboardType := TVirtualKeyboardType.default;
  fAutoCapitalizationType := TALAutoCapitalizationType.acNone;
  fCheckSpelling := true;
  FTintColor := TalphaColors.Null;
  {$IF defined(ALDPK)}
  FPassword := False;
  FMaxLength := 0;
  FText := '';
  {$ENDIF}
  SetPassword(false);
end;

{********************************************************************}
Function TALWinEditControl.CreateNativeView: TALWinNativeView;
begin
  {$IF defined(ALDPK)}
  Result := nil;
  {$ELSE}
  result := TALWinEditView.create(self);
  {$ENDIF}
end;

{********************************************************}
function TALWinEditControl.GetNativeView: TALWinEditView;
begin
  result := TALWinEditView(inherited GetNativeView);
end;

{*********************************************}
function TALWinEditControl.GetKeyboardType: TVirtualKeyboardType;
begin
  Result := FKeyboardType;
end;

{***********************************************************}
procedure TALWinEditControl.setKeyboardType(const Value: TVirtualKeyboardType);
begin
  FKeyboardType := Value;
end;

{************************************************************}
function TALWinEditControl.GetAutoCapitalizationType: TALAutoCapitalizationType;
begin
  result := fAutoCapitalizationType;
end;

{*************************************************************************************}
procedure TALWinEditControl.setAutoCapitalizationType(const Value: TALAutoCapitalizationType);
begin
  if (value <> fAutoCapitalizationType) then begin
    fAutoCapitalizationType := Value;
    {$IF not defined(ALDPK)}
    var LStyle := GetWindowLong(NativeView.Handle, GWL_STYLE);
    if LStyle = 0 then RaiseLastOsError;
    case fAutoCapitalizationType of
      TALAutoCapitalizationType.acNone:          LStyle := LStyle and not ES_UPPERCASE;
      TALAutoCapitalizationType.acWords:         LStyle := LStyle and not ES_UPPERCASE;
      TALAutoCapitalizationType.acSentences:     LStyle := LStyle and not ES_UPPERCASE;
      TALAutoCapitalizationType.acAllCharacters: LStyle := LStyle or ES_UPPERCASE;
      else raise Exception.Create('Error 21CC0DF5-9030-4F6C-9830-112E17E1A392');
    end;
    if SetWindowLong(NativeView.Handle, GWL_STYLE, LStyle) = 0 then RaiseLastOsError;
    {$ENDIF}
  end;
end;

{*****************************************************}
procedure TALWinEditControl.setPassword(const Value: Boolean);
begin
  {$IF defined(ALDPK)}
  FPassword := Value;
  {$ELSE}
  if (value <> Password) then begin
    if Value then SendMessage(NativeView.Handle, EM_SETPASSWORDCHAR, Ord('*'), 0)
    else SendMessage(NativeView.Handle, EM_SETPASSWORDCHAR, 0, 0);
    NativeView.Invalidate;
  end;
  {$ENDIF}
end;

{**************************************}
function TALWinEditControl.GetPassword: Boolean;
begin
  {$IF defined(ALDPK)}
  Result := FPassword;
  {$ELSE}
  Result := SendMessage(NativeView.Handle, EM_GETPASSWORDCHAR, 0, 0) <> 0;
  {$ENDIF}
end;

{**********************************************************}
procedure TALWinEditControl.SetMaxLength(const Value: integer);
begin
  {$IF defined(ALDPK)}
  FMaxLength := Value;
  {$ELSE}
  SendMessage(NativeView.Handle, EM_LIMITTEXT, Value, 0);
  {$ENDIF}
end;

{****************************************}
function TALWinEditControl.GetMaxLength: integer;
begin
  {$IF defined(ALDPK)}
  Result := FMaxLength;
  {$ELSE}
  Result := SendMessage(NativeView.Handle, EM_GETLIMITTEXT, 0, 0);
  if Result = $7FFFFFFE {2147483646} then Result := 0;
  {$ENDIF}
end;

{***********************************************}
function TALWinEditControl.GetCheckSpelling: Boolean;
begin
  result := FCheckSpelling
end;

{***********************************************}
procedure TALWinEditControl.setCheckSpelling(const Value: Boolean);
begin
  FCheckSpelling := Value;
end;

{***********************************************}
function TALWinEditControl.GetReturnKeyType: TReturnKeyType;
begin
  Result := FReturnKeyType;
end;

{***********************************************}
procedure TALWinEditControl.setReturnKeyType(const Value: TReturnKeyType);
begin
  FReturnKeyType := Value;
end;

{***********************************************}
function TALWinEditControl.GetPromptText: String;
begin
  Result := FPromptText;
end;

{**********************************************************}
procedure TALWinEditControl.setPromptText(const Value: String);
begin
  if FPromptText <> Value then begin
    FPromptText := Value;
    {$IF not defined(ALDPK)}
    NativeView.Invalidate;
    {$ENDIF}
  end;
end;

{*********************************************************}
function TALWinEditControl.GetPromptTextColor: TAlphaColor;
begin
  Result := FPromptTextColor;
end;

{********************************************************************}
procedure TALWinEditControl.setPromptTextColor(const Value: TAlphaColor);
begin
  if Value <> FPromptTextColor then begin
    FPromptTextColor := Value;
    {$IF not defined(ALDPK)}
    NativeView.Invalidate;
    {$ENDIF}
  end;
end;

{**********************************************************}
function TALWinEditControl.GetTintColor: TAlphaColor;
begin
  Result := FTintColor;
end;

{**********************************************************}
procedure TALWinEditControl.setTintColor(const Value: TAlphaColor);
begin
  FTintColor := Value;
end;

{**********************************************************}
function TALWinEditControl.GetFillColor: TAlphaColor;
begin
  Result := FFillColor;
end;

{**********************************************************}
procedure TALWinEditControl.SetFillColor(const Value: TAlphaColor);
begin
  if FFillColor <> Value then begin
    FFillColor := Value;
    {$IF not defined(ALDPK)}
    NativeView.UpdateBackgroundBrush;
    NativeView.Invalidate;
    {$ENDIF}
  end;
end;

{**************************************}
function TALWinEditControl.getText: String;
begin
  {$IF defined(ALDPK)}
  Result := FText;
  {$ELSE}
  Result := GetHWNDText(NativeView.Handle);
  {$ENDIF}
end;

{************************************************}
procedure TALWinEditControl.SetText(const Value: String);
begin
  {$IF defined(ALDPK)}
  FText := Value;
  {$ELSE}
  SetWindowText(NativeView.Handle, PChar(Value));
  {$ENDIF}
end;

{******************************************************}
procedure TALWinEditControl.TextSettingsChanged(Sender: TObject);
begin
  {$IF not defined(ALDPK)}
  NativeView.UpdateFontHandle;
  //--
  var LStyle := GetWindowLong(NativeView.Handle, GWL_STYLE);
  if LStyle = 0 then RaiseLastOsError;
  case TextSettings.HorzAlign of
      TALTextHorzAlign.Center:   LStyle := LStyle or ES_CENTER;
      TALTextHorzAlign.Leading:  LStyle := LStyle or ES_LEFT;
      TALTextHorzAlign.Trailing: LStyle := LStyle or ES_RIGHT;
      TALTextHorzAlign.Justify:  LStyle := LStyle or ES_LEFT;
    else raise Exception.Create('Error 21CC0DF5-9030-4F6C-9830-112E17E1A392');
  end;
  if SetWindowLong(NativeView.Handle, GWL_STYLE, LStyle) = 0 then RaiseLastOsError;
  SendMessage(NativeView.Handle, EM_SETMARGINS, EC_LEFTMARGIN or EC_RIGHTMARGIN, MakeLParam(0, 0));
  //--
  NativeView.Invalidate;
  {$ENDIF}
end;

{****************************************}
function TALWinEditControl.getLineHeight: Single;
begin
  var LfontMetrics := ALGetFontMetrics(
                        TextSettings.Font.Family, // const AFontFamily: String;
                        TextSettings.Font.Size, // const AFontSize: single;
                        TextSettings.Font.Weight, // const AFontWeight: TFontWeight;
                        TextSettings.Font.Slant, // const AFontSlant: TFontSlant;
                        TextSettings.Font.Color, // const AFontColor: TalphaColor;
                        TextSettings.Decoration.Kinds); // const ADecorationKinds: TALTextDecorationKinds;
  result := -LfontMetrics.Ascent + LfontMetrics.Descent + LfontMetrics.Leading;
  // The classic Edit control doesn't natively support line spacing adjustments
  // if not SameValue(textsettings.LineHeightMultiplier, 0, TEpsilon.Scale) then
  //   result := result * textsettings.LineHeightMultiplier;
end;

{$endif}
{$ENDREGION}

{******************************************}
constructor TALEditLabelTextSettings.Create;
begin
  inherited create;
  FMargins := TBounds.Create(TRectF.Create(0,0,0,-8));
  FMargins.OnChange := MarginsChanged;
  FLayout := TALEditLabelTextLayout.Floating;
  FAnimation := TALEditLabelTextAnimation.Translation;
end;

{******************************************}
destructor TALEditLabelTextSettings.Destroy;
begin
  ALFreeAndNil(FMargins);
  Inherited Destroy;
end;

{***************************************}
procedure TALEditLabelTextSettings.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Margins.Rect := Margins.DefaultValue;
    Layout := TALEditLabelTextLayout.Floating;
    Animation := TALEditLabelTextAnimation.Translation;
  finally
    EndUpdate;
  end;
end;

{******************************************************************}
procedure TALEditLabelTextSettings.SetMargins(const Value: TBounds);
begin
  FMargins.Assign(Value);
end;

{********************************************************************************}
procedure TALEditLabelTextSettings.SetLayout(const Value: TALEditLabelTextLayout);
begin
  if FLayout <> Value then begin
    FLayout := Value;
    Change;
  end;
end;

{**************************************************************************************}
procedure TALEditLabelTextSettings.SetAnimation(const Value: TALEditLabelTextAnimation);
begin
  if FAnimation <> Value then begin
    FAnimation := Value;
    Change;
  end;
end;

{*****************************************************************}
procedure TALEditLabelTextSettings.MarginsChanged(Sender: TObject);
begin
  Change;
end;

{***********************************************}
constructor TALEditSupportingTextSettings.Create;
begin
  inherited create;
  FMargins := TBounds.Create(TRectF.Create(0,4,0,0));
  FMargins.OnChange := MarginsChanged;
  FLayout := TALEditSupportingTextLayout.Floating;
end;

{***********************************************}
destructor TALEditSupportingTextSettings.Destroy;
begin
  ALFreeAndNil(FMargins);
  Inherited Destroy;
end;

{********************************************}
procedure TALEditSupportingTextSettings.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Margins.Rect := Margins.DefaultValue;
    Layout := TALEditSupportingTextLayout.Floating;
  finally
    EndUpdate;
  end;
end;

{***********************************************************************}
procedure TALEditSupportingTextSettings.SetMargins(const Value: TBounds);
begin
  FMargins.Assign(Value);
end;

{******************************************************************************************}
procedure TALEditSupportingTextSettings.SetLayout(const Value: TALEditSupportingTextLayout);
begin
  if FLayout <> Value then begin
    FLayout := Value;
    Change;
  end;
end;

{**********************************************************************}
procedure TALEditSupportingTextSettings.MarginsChanged(Sender: TObject);
begin
  Change;
end;

{***********************************}
constructor TALEditBaseStateStyle.Create(const AParent: TObject);
begin
  inherited Create(AParent);
  FPromptTextColor := TalphaColors.Null;
  FTintColor := TalphaColors.Null;
  //--
  if StateStyleParent <> nil then begin
    {$IF defined(debug)}
    if not (StateStyleParent is TALEditBaseStateStyle) then
      raise Exception.Create('Error 907D5340-D79D-4FDE-B0BF-06BCFD4B6C57');
    {$ENDIF}
    var LParent := TALEditBaseStateStyle(StateStyleParent);
    FTextSettings := TALEditStateStyleTextSettings.Create(LParent.TextSettings);
    FLabelTextSettings := TALEditStateStyleTextSettings.Create(LParent.LabelTextSettings);
    FSupportingTextSettings := TALEditStateStyleTextSettings.Create(LParent.SupportingTextSettings);
  end
  else begin
    {$IF defined(debug)}
    if not (ControlParent is TALBaseEdit) then
      raise Exception.Create('Error 07F2490E-92B7-445B-9AD5-FFE0695C5583');
    {$ENDIF}
    var LParent := TALBaseEdit(ControlParent);
    FTextSettings := TALEditStateStyleTextSettings.Create(LParent.TextSettings);
    FLabelTextSettings := TALEditStateStyleTextSettings.Create(LParent.LabelTextSettings);
    FSupportingTextSettings := TALEditStateStyleTextSettings.Create(LParent.SupportingTextSettings);
  end;
  //--
  Stroke.DefaultColor := $FF7a7a7a;
  Stroke.Color := Stroke.DefaultColor;
  //--
  FTextSettings.OnChanged := TextSettingsChanged;
  FLabelTextSettings.OnChanged := LabelTextSettingsChanged;
  FSupportingTextSettings.OnChanged := SupportingTextSettingsChanged;
  //--
  //FPriorSupersedePromptTextColor
  //FPriorSupersedeTintColor
end;

{*************************************}
destructor TALEditBaseStateStyle.Destroy;
begin
  ALFreeAndNil(FTextSettings);
  ALFreeAndNil(FLabelTextSettings);
  ALFreeAndNil(FSupportingTextSettings);
  inherited Destroy;
end;

{******************************************************}
procedure TALEditBaseStateStyle.Assign(Source: TPersistent);
begin
  if Source is TALEditBaseStateStyle then begin
    BeginUpdate;
    Try
      PromptTextColor := TALEditBaseStateStyle(Source).PromptTextColor;
      TintColor := TALEditBaseStateStyle(Source).TintColor;
      TextSettings.Assign(TALEditBaseStateStyle(Source).TextSettings);
      LabelTextSettings.Assign(TALEditBaseStateStyle(Source).LabelTextSettings);
      SupportingTextSettings.Assign(TALEditBaseStateStyle(Source).SupportingTextSettings);
      inherited Assign(Source);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{************************************}
procedure TALEditBaseStateStyle.DoSupersede;
begin
  inherited;
  //--
  FPriorSupersedePromptTextColor := FPromptTextColor;
  FPriorSupersedeTintColor := FTintColor;
  //--
  if StateStyleParent <> nil then begin
    if FPromptTextColor = TAlphaColors.Null then
      FPromptTextColor := TALEditBaseStateStyle(StateStyleParent).FPromptTextColor;
    if FTintColor = TAlphaColors.Null then
      FTintColor := TALEditBaseStateStyle(StateStyleParent).FTintColor;
  end
  else begin
    if FPromptTextColor = TAlphaColors.Null then
      FPromptTextColor := TALBaseEdit(ControlParent).FPromptTextColor;
    if FTintColor = TAlphaColors.Null then
      FTintColor := TALBaseEdit(ControlParent).FTintColor;
  end;
  FTextSettings.Supersede;
  FLabelTextSettings.Supersede;
  FSupportingTextSettings.Supersede;
end;

{************************************}
procedure TALEditBaseStateStyle.DoReinstate;
begin
  inherited;
  FPromptTextColor := FPriorSupersedePromptTextColor;
  FTintColor := FPriorSupersedeTintColor;
  FTextSettings.Reinstate;
  FLabelTextSettings.Reinstate;
  FSupportingTextSettings.Reinstate;
end;

{****************************************************************************}
procedure TALEditBaseStateStyle.SetPromptTextColor(const AValue: TAlphaColor);
begin
  if FPromptTextColor <> AValue then begin
    FPromptTextColor := AValue;
    Change;
  end;
end;

{****************************************************************************}
procedure TALEditBaseStateStyle.SetTintColor(const AValue: TAlphaColor);
begin
  if FTintColor <> AValue then begin
    FTintColor := AValue;
    Change;
  end;
end;

{*******************************************************************************************}
procedure TALEditBaseStateStyle.SetTextSettings(const AValue: TALEditStateStyleTextSettings);
begin
  FTextSettings.Assign(AValue);
end;

{*******************************************************************************************}
procedure TALEditBaseStateStyle.SetLabelTextSettings(const AValue: TALEditStateStyleTextSettings);
begin
  FLabelTextSettings.Assign(AValue);
end;

{*******************************************************************************************}
procedure TALEditBaseStateStyle.SetSupportingTextSettings(const AValue: TALEditStateStyleTextSettings);
begin
  FSupportingTextSettings.Assign(AValue);
end;

{***********************************************}
function TALEditBaseStateStyle.GetInherit: Boolean;
begin
  Result := inherited GetInherit and
            (PromptTextColor <> TalphaColors.Null) and
            (TintColor <> TalphaColors.Null) and
            TextSettings.Inherit and
            LabelTextSettings.Inherit and
            SupportingTextSettings.Inherit;
end;

{******************************************************************}
procedure TALEditBaseStateStyle.TextSettingsChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
procedure TALEditBaseStateStyle.LabelTextSettingsChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
procedure TALEditBaseStateStyle.SupportingTextSettingsChanged(ASender: TObject);
begin
  Change;
end;

{**********************************************************}
function TALEditDisabledStateStyle.IsOpacityStored: Boolean;
begin
  Result := not SameValue(FOpacity, TControl.DefaultDisabledOpacity, TEpsilon.Scale);
end;

{********************************************************************}
procedure TALEditDisabledStateStyle.SetOpacity(const Value: Single);
begin
  if not SameValue(FOpacity, Value, TEpsilon.Scale) then begin
    FOpacity := Value;
    Change;
  end;
end;

{*********************************************}
constructor TALEditDisabledStateStyle.Create(const AParent: TObject);
begin
  inherited Create(AParent);
  FOpacity := TControl.DefaultDisabledOpacity;
end;

{****************************************************************}
procedure TALEditDisabledStateStyle.Assign(Source: TPersistent);
begin
  BeginUpdate;
  Try
    if Source is TALEditDisabledStateStyle then
      Opacity := TALEditDisabledStateStyle(Source).Opacity
    else
      Opacity := TControl.DefaultDisabledOpacity;
    inherited Assign(Source);
  Finally
    EndUpdate;
  End;
end;

{****************************************************************}
constructor TALEditStateStyles.Create(const AParent: TALBaseEdit);
begin
  inherited Create;
  //--
  FDisabled := TALEditDisabledStateStyle.Create(AParent);
  FDisabled.OnChanged := DisabledChanged;
  //--
  FHovered := TALEditHoveredStateStyle.Create(AParent);
  FHovered.OnChanged := HoveredChanged;
  //--
  FFocused := TALEditFocusedStateStyle.Create(AParent);
  FFocused.OnChanged := FocusedChanged;
end;

{*************************************}
destructor TALEditStateStyles.Destroy;
begin
  ALFreeAndNil(FDisabled);
  ALFreeAndNil(FHovered);
  ALFreeAndNil(FFocused);
  inherited Destroy;
end;

{******************************************************}
procedure TALEditStateStyles.Assign(Source: TPersistent);
begin
  if Source is TALEditStateStyles then begin
    BeginUpdate;
    Try
      Disabled.Assign(TALEditStateStyles(Source).Disabled);
      Hovered.Assign(TALEditStateStyles(Source).Hovered);
      Focused.Assign(TALEditStateStyles(Source).Focused);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{************************************************************************************}
procedure TALEditStateStyles.SetDisabled(const AValue: TALEditDisabledStateStyle);
begin
  FDisabled.Assign(AValue);
end;

{************************************************************************************}
procedure TALEditStateStyles.SetHovered(const AValue: TALEditHoveredStateStyle);
begin
  FHovered.Assign(AValue);
end;

{*******************************************************************************************}
procedure TALEditStateStyles.SetFocused(const AValue: TALEditFocusedStateStyle);
begin
  FFocused.Assign(AValue);
end;

{**********************************************************}
procedure TALEditStateStyles.DisabledChanged(ASender: TObject);
begin
  Change;
end;

{************************************************************}
procedure TALEditStateStyles.HoveredChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
procedure TALEditStateStyles.FocusedChanged(ASender: TObject);
begin
  Change;
end;

{*********************************************}
constructor TALBaseEdit.Create(AOwner: TComponent);
begin
  inherited;
  fDefStyleAttr := '';
  fDefStyleRes := '';
  FAutoTranslate := true;
  fOnChangeTracking := nil;
  FOnReturnKey := nil;
  fOnEnter := nil;
  fOnExit := nil;
  FTextSettings := CreateTextSettings;
  FTextSettings.Font.DefaultSize := 16;
  FTextSettings.Font.Size := FTextSettings.Font.DefaultSize;
  FTextSettings.OnChanged := TextSettingsChanged;
  FPromptText := '';
  FPromptTextColor := TAlphaColors.null;
  FTintcolor := TAlphaColors.null;
  FLabelText := '';
  FLabelTextSettings := TALEditLabelTextSettings.create;
  FLabelTextSettings.Font.DefaultSize := 12;
  FLabelTextSettings.Font.Size := FLabelTextSettings.Font.DefaultSize;
  FLabelTextSettings.OnChanged := LabelTextSettingsChanged;
  FlabelTextAnimation := TALFloatAnimation.Create;
  FlabelTextAnimation.StartValue := 0;
  FlabelTextAnimation.StopValue := 1;
  FlabelTextAnimation.AnimationType := TanimationType.out;
  FlabelTextAnimation.Interpolation := TALInterpolationType.linear;
  FlabelTextAnimation.OnProcess := labelTextAnimationProcess;
  FlabelTextAnimation.OnFinish := labelTextAnimationFinish;
  FSupportingText := '';
  FSupportingTextSettings := TALEditSupportingTextSettings.Create;
  FSupportingTextSettings.Font.DefaultSize := 12;
  FSupportingTextSettings.Font.Size := FSupportingTextSettings.Font.DefaultSize;
  FSupportingTextSettings.OnChanged := SupportingTextSettingsChanged;
  FSupportingTextMarginBottomUpdated := False;
  FHovered := False;
  FStateStyles := TALEditStateStyles.Create(Self);
  FStateStyles.OnChanged := StateStylesChanged;
  FIsTextEmpty := True;
  FNativeViewRemoved := False;
  FIsAdjustingSize := False;
  //--
  fBufDisabledDrawable := ALNullDrawable;
  fBufHoveredDrawable := ALNullDrawable;
  fBufFocusedDrawable := ALNullDrawable;
  //--
  fBufPromptTextDrawable := ALNullDrawable;
  fBufPromptTextDisabledDrawable := ALNullDrawable;
  fBufPromptTextHoveredDrawable := ALNullDrawable;
  fBufPromptTextFocusedDrawable := ALNullDrawable;
  //--
  fBufLabelTextDrawable := ALNullDrawable;
  fBufLabelTextDisabledDrawable := ALNullDrawable;
  fBufLabelTextHoveredDrawable := ALNullDrawable;
  fBufLabelTextFocusedDrawable := ALNullDrawable;
  //--
  fBufSupportingTextDrawable := ALNullDrawable;
  fBufSupportingTextDisabledDrawable := ALNullDrawable;
  fBufSupportingTextHoveredDrawable := ALNullDrawable;
  fBufSupportingTextFocusedDrawable := ALNullDrawable;
  //--
  FocusOnMouseUp := True;
  Cursor := crIBeam;
  CanFocus := True;
  var LFillChanged: TNotifyEvent := fill.OnChanged;
  fill.OnChanged := nil;
  fill.DefaultColor := $ffffffff;
  fill.Color := fill.DefaultColor;
  fill.OnChanged := LFillChanged;
  var LStrokeChanged: TNotifyEvent := stroke.OnChanged;
  stroke.OnChanged := Nil;
  stroke.DefaultColor := $FF7a7a7a;
  stroke.Color := stroke.DefaultColor;
  stroke.OnChanged := LStrokeChanged;
  var LPaddingChange: TNotifyEvent := Padding.OnChange;
  Padding.OnChange := nil;
  Padding.DefaultValue := TRectF.create(16{Left}, 16{Top}, 16{Right}, 16{Bottom});
  Padding.Rect := Padding.DefaultValue;
  padding.OnChange := LPaddingChange;
  //-----
  {$IF defined(DEBUG)}
  if fEditControl <> nil then
    raise Exception.Create('Error CE2932F6-E44A-4A4B-AAE3-71FE4077FCF2');
  {$ENDIF}
  {$IF defined(android)}
  // In Android we must first know the value of DefStyleAttr/DefStyleRes
  // before to create the fEditControl. I use this way to know that the compoment
  // will load it's properties from the dfm
  if (aOwner = nil) or
     (not (csloading in aOwner.ComponentState)) then begin
    fEditControl := CreateEditControl;
    InitEditControl;
  end
  else fEditControl := nil;
  {$ELSE}
  fEditControl := CreateEditControl;
  InitEditControl;
  {$ENDIF}
end;

{*************************}
destructor TALBaseEdit.Destroy;
begin
  ALFreeAndNil(FTextSettings);
  ALFreeAndNil(FLabelTextSettings);
  ALFreeAndNil(FlabelTextAnimation);
  ALFreeAndNil(FSupportingTextSettings);
  ALFreeAndNil(FStateStyles);
  ALFreeAndNil(fEditControl);
  inherited Destroy;
end;

{***********************************************************}
function TALBaseEdit.CreateTextSettings: TALEditTextSettings;
begin
  result := TALEditTextSettings.Create;
end;

{*********************************************************}
function TALBaseEdit.CreateEditControl: TALBaseEditControl;
begin
  {$IF defined(android)}
  Result := TALAndroidEditControl.Create(self, false{aIsMultiline}, DefStyleAttr, DefStyleRes);
  {$ELSEIF defined(ios)}
  Result := TALIosEditControl.Create(self);
  {$ELSEIF defined(ALMacOS)}
  Result := TALMacEditControl.Create(self);
  {$ELSEIF defined(MSWindows)}
  Result := TALWinEditControl.Create(self);
  {$ELSE}
    Not implemented
  {$ENDIF}
end;

{********************************}
procedure TALBaseEdit.InitEditControl;
begin
  fEditControl.Parent := self;
  FeditControl.Stored := False;
  FeditControl.SetSubComponent(True);
  FeditControl.Locked := True;
  FeditControl.OnReturnKey := nil; // noops operation
  fEditControl.Align := TAlignLayout.Client;
  FeditControl.OnChangeTracking := OnChangeTrackingImpl;
  FeditControl.OnEnter := OnEnterImpl;
  FeditControl.OnExit := OnExitImpl;
  fEditControl.Password := false; // noops operation
  fEditControl.ReturnKeyType := tReturnKeyType.Default;  // noops operation
  fEditControl.KeyboardType := TVirtualKeyboardType.Default; // noops operation
  fEditControl.AutoCapitalizationType := TALAutoCapitalizationType.acNone; // noops operation
  fEditControl.CheckSpelling := True;
  fEditControl.MaxLength := 0; // noops operation
  fEditControl.PromptTextColor := TALphaColors.Null; // noops operation
  fEditControl.TintColor := TALphaColors.Null; // noops operation
  fEditControl.FillColor := $ffffffff; // noops operation
  fEditControl.CanFocus := False;
  fEditControl.CanParentFocus := True;
  fEditControl.HitTest := False;
end;

{***********************}
procedure TALBaseEdit.Loaded;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  procedure _ConvertFontFamily(const AStateStyle: TALEditBaseStateStyle);
  begin
    if (AStateStyle.TextSettings.Font.AutoConvert) and
       (AStateStyle.TextSettings.Font.Family <> '') and
       (not (csDesigning in ComponentState)) then
      AStateStyle.TextSettings.Font.Family := ALConvertFontFamily(AStateStyle.TextSettings.Font.Family);
  end;

begin
  if FEditControl = nil then begin
    FEditControl := CreateEditControl;
    InitEditControl;
  end;
  //--
  // csLoading is in ComponentState
  if (TextSettings.Font.AutoConvert) and
     (TextSettings.Font.Family <> '') and
     (not (csDesigning in ComponentState)) then
    TextSettings.Font.Family := ALConvertFontFamily(TextSettings.Font.Family);
  //--
  if (LabelTextSettings.Font.AutoConvert) and
     (LabelTextSettings.Font.Family <> '') and
     (not (csDesigning in ComponentState)) then
    LabelTextSettings.Font.Family := ALConvertFontFamily(LabelTextSettings.Font.Family);
  //--
  _ConvertFontFamily(StateStyles.Disabled);
  _ConvertFontFamily(StateStyles.Hovered);
  _ConvertFontFamily(StateStyles.Focused);
  //--
  // remove csLoading from ComponentState
  inherited;
  //--
  if (AutoTranslate) and
     (PromptText <> '') and
     (not (csDesigning in ComponentState)) then
    PromptText := ALTranslate(PromptText);
  //--
  if (AutoTranslate) and
     (LabelText <> '') and
     (not (csDesigning in ComponentState)) then
    LabelText := ALTranslate(LabelText);
  //--
  if (AutoTranslate) and
     (SupportingText <> '') and
     (not (csDesigning in ComponentState)) then
    SupportingText := ALTranslate(SupportingText);
  //--
  FIsTextEmpty := GetText = '';
  //--
  TextSettingsChanged(TextSettings);
  //--
  //AdjustSize; => Already called in TextSettingsChanged
  //UpdateEditControlStyle => Already called in TextSettingsChanged
  //--
  UpdateEditControlPromptText;
  UpdateNativeViewVisibility;
end;

{*****************************************************}
procedure TALBaseEdit.SetDefStyleAttr(const Value: String);
begin
  if Value <> fDefStyleAttr then begin
    fDefStyleAttr := Value;
    {$IFDEF ANDROID}
    if not (csLoading in componentState) then begin
      ALFreeAndNil(fEditControl);
      FEditControl := CreateEditControl;
      InitEditControl;
    end;
    {$ENDIF}
  end;
end;

{****************************************************}
procedure TALBaseEdit.SetDefStyleRes(const Value: String);
begin
  if Value <> fDefStyleRes then begin
    fDefStyleRes := Value;
    {$IFDEF ANDROID}
    if not (csLoading in componentState) then begin
      ALFreeAndNil(fEditControl);
      FEditControl := CreateEditControl;
      InitEditControl;
    end;
    {$ENDIF}
  end;
end;

{**************************************}
function TALBaseEdit.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(200, 50);
end;

{********************}
{$IF defined(android)}
function TALBaseEdit.GetEditControl: TALBaseEditControl;
begin
  if FEditControl = nil then begin
    FEditControl := CreateEditControl;
    InitEditControl;
  end;
  Result := FEditControl;
end;
{$ENDIF}

{********************}
{$IF defined(android)}
function TALBaseEdit.GetNativeView: TALAndroidNativeView;
begin
  result := EditControl.NativeView;
end;
{$ENDIF}

{****************}
{$IF defined(IOS)}
function TALBaseEdit.GetEditControl: TALBaseEditControl;
begin
  if FEditControl = nil then begin
    FEditControl := CreateEditControl;
    InitEditControl;
  end;
  Result := FEditControl;
end;
{$ENDIF}

{****************}
{$IF defined(IOS)}
function TALBaseEdit.GetNativeView: TALIosNativeView;
begin
  result := EditControl.NativeView;
end;
{$ENDIF}

{******************}
{$IF defined(ALMacOS)}
function TALBaseEdit.GetEditControl: TALBaseEditControl;
begin
  if FEditControl = nil then begin
    FEditControl := CreateEditControl;
    InitEditControl;
  end;
  Result := FEditControl;
end;
{$ENDIF}

{******************}
{$IF defined(ALMacOS)}
function TALBaseEdit.GetNativeView: TALMacNativeView;
begin
  result := EditControl.NativeView;
end;
{$ENDIF}

{**********************}
{$IF defined(MSWindows)}
function TALBaseEdit.GetEditControl: TALBaseEditControl;
begin
  if FEditControl = nil then begin
    FEditControl := CreateEditControl;
    InitEditControl;
  end;
  Result := FEditControl;
end;
{$ENDIF}

{**********************}
{$IF defined(MSWindows)}
function TALBaseEdit.GetNativeView: TALWinNativeView;
begin
  result := EditControl.NativeView;
end;
{$ENDIF}

{************************}
procedure TALBaseEdit.DoEnter;
begin
  {$IF defined(DEBUG)}
  ALLog('TALBaseEdit.DoEnter', 'control.name: ' + Name, TalLogType.VERBOSE);
  {$ENDIF}
  inherited DoEnter;
  UpdateEditControlStyle;
  //--
  if (GetIsTextEmpty) and
     (HasTranslationLabelTextAnimation) then begin
    FlabelTextAnimation.StopAtCurrent;
    FlabelTextAnimation.Inverse := False;
    FlabelTextAnimation.Duration := 0.15;
    FLabelTextAnimation.Start;
  end;
  //--
  {$IF not defined(ALDPK)}
  NativeView.SetFocus;
  {$ENDIF}
  {$IF defined(android)}
  if IsFocused then begin
    ALVirtualKeyboardVisible := True;
    {$IF defined(DEBUG)}
    ALLog('TALBaseEdit.showVirtualKeyboard', 'control.name: ' + Name, TalLogType.VERBOSE);
    {$ENDIF}
    MainActivity.getVirtualKeyboard.showFor(NativeView.View);
  end;
  {$ENDIF}
end;

{***********************}
procedure TALBaseEdit.DoExit;
begin
  {$IF defined(DEBUG)}
  ALLog('TALBaseEdit.DoExit', 'control.name: ' + Name, TalLogType.VERBOSE);
  {$ENDIF}
  inherited DoExit;
  UpdateEditControlStyle;
  UpdateNativeViewVisibility;
  //--
  if (GetIsTextEmpty) and
     (HasTranslationLabelTextAnimation) then begin
    FlabelTextAnimation.StopAtCurrent;
    FlabelTextAnimation.Inverse := True;
    FlabelTextAnimation.Duration := 0.10;
    FLabelTextAnimation.Start;
  end;
  //--
  {$IF not defined(ALDPK)}
  NativeView.ResetFocus;
  {$ENDIF}
  {$IF defined(android)}
  ALVirtualKeyboardVisible := False;
  TThread.ForceQueue(nil,
    procedure
    begin
      If not ALVirtualKeyboardVisible then begin
        {$IF defined(DEBUG)}
        ALLog('TALBaseEdit.hideVirtualKeyboard', TalLogType.VERBOSE);
        {$ENDIF}
        MainActivity.getVirtualKeyboard.hide;
      end;
    end);
  {$ENDIF}
end;

{***************************************}
procedure TALBaseEdit.UpdateEditControlStyle;
begin

  if (csLoading in ComponentState) then exit;

  var LStateStyle: TALEditBaseStateStyle;
  if Not Enabled then LStateStyle := StateStyles.Disabled
  else if IsFocused then LStateStyle := StateStyles.Focused
  else if FHovered then LStateStyle := StateStyles.Hovered
  else LStateStyle := nil;
  if LStateStyle <> nil then
    LStateStyle.Supersede;
  try
    // FillColor
    if LStateStyle <> nil then EditControl.FillColor := LStateStyle.Fill.Color
    else EditControl.FillColor := Fill.Color;
    // PromptTextColor
    if LStateStyle <> nil then EditControl.PromptTextColor := LStateStyle.PromptTextColor
    else EditControl.PromptTextColor := PromptTextColor;
    // TintColor
    if LStateStyle <> nil then EditControl.TintColor := LStateStyle.TintColor
    else EditControl.TintColor := TintColor;
    // TextSettings
    if LStateStyle <> nil then EditControl.TextSettings.Assign(LStateStyle.TextSettings)
    else EditControl.TextSettings.Assign(TextSettings)
  finally
    if LStateStyle <> nil then
      LStateStyle.Reinstate;
  end;

  repaint;

end;

{**************************************************}
procedure TALBaseEdit.SetHovered(const AValue: Boolean);
begin
  If FHovered <> AValue then begin
    FHovered := AValue;
    UpdateEditControlStyle;
  end;
end;

{********************************************}
function TALBaseEdit.GetControlType: TControlType;
begin
  // We need ControlType because in function TFMXViewBase.canBecomeFirstResponder: Boolean;
  // we use it in IsNativeControl to determine if it's a native control or not
  Result := TControlType.Platform;
end;

{**********************************************************}
procedure TALBaseEdit.SetControlType(const Value: TControlType);
begin
  // The ControlType cannot be changed
end;

{***********************************************************}
procedure TALBaseEdit.LabelTextAnimationProcess(Sender: TObject);
begin
  Repaint;
end;

{**********************************************************}
procedure TALBaseEdit.LabelTextAnimationFinish(Sender: TObject);
begin
  FLabelTextAnimation.Enabled := False;
  UpdateNativeViewVisibility;
  Repaint;
end;

{******************************************************}
function TALBaseEdit.HasOpacityLabelTextAnimation: Boolean;
begin
  result := (LabelTextSettings.Layout = TALEditLabelTextLayout.Floating) and
            (LabelTextSettings.Animation = TALEditLabelTextAnimation.Opacity) and
            (LabelText <> '') and
            ((prompttext = '') or (prompttext = labeltext));
end;

{*********************************************************}
function TALBaseEdit.HasTranslationLabelTextAnimation: Boolean;
begin
  result := ((LabelTextSettings.Layout = TALEditLabelTextLayout.Inline) or
             ((LabelTextSettings.Layout = TALEditLabelTextLayout.Floating) and
              (LabelTextSettings.Animation = TALEditLabelTextAnimation.Translation))) and
            (LabelText <> '') and
            ((PromptText = '') or (PromptText = LabelText));
end;

{************************************************************}
procedure TALBaseEdit.MouseMove(Shift: TShiftState; X, Y: Single);
begin
  inherited;
  SetHovered(True);
end;

{*****************************}
procedure TALBaseEdit.DoMouseEnter;
begin
  inherited DoMouseEnter;
  SetHovered(True);
end;

{*****************************}
procedure TALBaseEdit.DoMouseLeave;
begin
  inherited DoMouseLeave;
  {$IF defined(MSWindows)}
  IF (Root is TCustomForm) then begin
    var LMousePos := AbsoluteToLocal(TCustomForm(Root).ScreenToClient(Screen.MousePos));
    if not LocalRect.Contains(LMousePos) then SetHovered(False);
  end
  else
    SetHovered(False);
  {$ELSE}
  SetHovered(False);
  {$ENDIF}
  Repaint;
end;

{************************************************************}
procedure TALBaseEdit.SetTextSettings(const Value: TALEditTextSettings);
begin
  FTextSettings.Assign(Value);
end;

{*****************************************************}
procedure TALBaseEdit.TextSettingsChanged(Sender: TObject);
begin
  if csLoading in componentState then exit;
  ClearBufPromptTextDrawable;
  UpdateEditControlStyle;
  AdjustSize;
end;

{****************************************************************************}
procedure TALBaseEdit.SetLabelTextSettings(const Value: TALEditLabelTextSettings);
begin
  FLabelTextSettings.Assign(Value);
end;

{**********************************************************}
procedure TALBaseEdit.LabelTextSettingsChanged(Sender: TObject);
begin
  if csLoading in componentState then exit;
  ClearBufLabelTextDrawable;
  UpdateEditControlPromptText;
  UpdateNativeViewVisibility;
  AdjustSize;
  repaint;
end;

{**************************************************************************************}
procedure TALBaseEdit.SetSupportingTextSettings(const Value: TALEditSupportingTextSettings);
begin
  FSupportingTextSettings.Assign(Value);
end;

{***************************************************************}
procedure TALBaseEdit.SupportingTextSettingsChanged(Sender: TObject);
begin
  if csLoading in componentState then exit;
  ClearBufSupportingTextDrawable;
  repaint;
end;

{*****************************************************************}
procedure TALBaseEdit.SetStateStyles(const AValue: TALEditStateStyles);
begin
  FStateStyles.Assign(AValue);
end;

{****************************************************}
procedure TALBaseEdit.StateStylesChanged(Sender: TObject);
begin
  clearBufDrawable;
  DisabledOpacity := StateStyles.Disabled.opacity;
  UpdateEditControlStyle;
  Repaint;
end;

{*********************************************}
procedure TALBaseEdit.SetText(const Value: String);
begin
  EditControl.Text := Value;
  {$IF defined(ALDPK)}
  ClearBufPromptTextDrawable;
  ClearBufLabelTextDrawable;
  repaint;
  {$ENDIF}
end;

{*******************************}
function TALBaseEdit.getText: String;
begin
  result := EditControl.Text;
end;

{***********************************************}
procedure TALBaseEdit.UpdateNativeViewVisibility;
begin
  if {$IF defined(ALDPK)}true or{$ENDIF}
     (not Enabled) or
     ((GetIsTextEmpty) and (HasTranslationLabelTextAnimation) and (not IsFocused)) then
    EditControl.RemoveNativeView
  else if not FNativeViewRemoved then
    EditControl.AddNativeView;
end;

{********************************************}
procedure TALBaseEdit.UpdateEditControlPromptText;
begin
  if HasTranslationLabelTextAnimation then EditControl.PromptText := ''
  else if FPromptText<>'' then EditControl.PromptText := FPromptText
  else EditControl.PromptText := FLabelText;
end;

{*************************************}
function TALBaseEdit.GetPromptText: String;
begin
  result := FPromptText;
end;

{***************************************************}
procedure TALBaseEdit.setPromptText(const Value: String);
begin
  if FPromptText <> Value then begin
    ClearBufPromptTextDrawable;
    FPromptText := Value;
    UpdateEditControlPromptText;
    UpdateNativeViewVisibility;
    repaint;
  end;
end;

{***********************************************}
function TALBaseEdit.GetPromptTextColor: TAlphaColor;
begin
  result := FPromptTextColor;
end;

{*************************************************************}
procedure TALBaseEdit.setPromptTextColor(const Value: TAlphaColor);
begin
  if FPromptTextColor <> Value then begin
    ClearBufPromptTextDrawable;
    FPromptTextColor := Value;
    UpdateEditControlStyle;
  end;
end;

{**************************************************}
procedure TALBaseEdit.setLabelText(const Value: String);
begin
  if FLabelText <> Value then begin
    ClearBufPromptTextDrawable;
    ClearBufLabelTextDrawable;
    FLabelText := Value;
    UpdateEditControlPromptText;
    UpdateNativeViewVisibility;
    if FLabelTextSettings.Layout = TALEditLabelTextLayout.Inline then
      AdjustSize;
    Repaint;
  end;
end;

{*******************************************************}
procedure TALBaseEdit.setSupportingText(const Value: String);
begin
  if FSupportingText <> Value then begin
    ClearBufSupportingTextDrawable;
    FSupportingText := Value;
    Repaint;
  end;
end;

{*****************************************}
function TALBaseEdit.GetTintColor: TAlphaColor;
begin
  result := FTintColor;
end;

{*******************************************************}
procedure TALBaseEdit.setTintColor(const Value: TAlphaColor);
begin
  if FTintColor <> Value then begin
    FTintColor := Value;
    UpdateEditControlStyle;
  end;
end;

{*************************************************************}
procedure TALBaseEdit.SetKeyboardType(Value: TVirtualKeyboardType);
begin
  EditControl.KeyboardType := Value;
end;

{*****************************************************}
function TALBaseEdit.GetKeyboardType: TVirtualKeyboardType;
begin
  result := EditControl.KeyboardType;
end;

{********************************************************************}
function TALBaseEdit.GetAutoCapitalizationType: TALAutoCapitalizationType;
begin
  result := EditControl.AutoCapitalizationType;
end;

{**********************************************************************************}
procedure TALBaseEdit.setAutoCapitalizationType(const Value: TALAutoCapitalizationType);
begin
  EditControl.AutoCapitalizationType := Value;
end;

{**************************************************}
procedure TALBaseEdit.SetPassword(const Value: Boolean);
begin
  EditControl.Password := Value;
  clearBufPromptTextDrawable;
end;

{************************************}
function TALBaseEdit.GetPassword: Boolean;
begin
  result := EditControl.Password;
end;

{*******************************************************}
procedure TALBaseEdit.SetCheckSpelling(const Value: Boolean);
begin
  EditControl.CheckSpelling := Value;
end;

{*****************************************}
function TALBaseEdit.GetCheckSpelling: Boolean;
begin
  result := EditControl.CheckSpelling;
end;

{**************************************************************}
procedure TALBaseEdit.SetReturnKeyType(const Value: TReturnKeyType);
begin
  EditControl.ReturnKeyType := Value;
end;

{************************************************}
function TALBaseEdit.GetReturnKeyType: TReturnKeyType;
begin
  result := EditControl.ReturnKeyType;
end;

{***************************************************}
procedure TALBaseEdit.SetMaxLength(const Value: integer);
begin
  EditControl.MaxLength := Value;
end;

{*************************************}
function TALBaseEdit.GetMaxLength: integer;
begin
  result := EditControl.MaxLength;
end;

{***************************************}
function TALBaseEdit.GetIsTextEmpty: Boolean;
begin
  // FIsTextEmpty is used here because I believe that
  // GetText could be a little slow, and it's called
  // in every paint cycle.
  {$IF defined(ALDPK)}
  Result := GetText = '';
  {$ELSE}
  Result := FIsTextEmpty;
  {$ENDIF}
end;

{******************************************************}
procedure TALBaseEdit.OnChangeTrackingImpl(Sender: TObject);
begin
  if (csLoading in componentState) then exit;
  var LIsTextEmpty := GetText = '';
  if (LIsTextEmpty <> FIsTextEmpty) and
     (HasOpacityLabelTextAnimation) then begin
    FIsTextEmpty := LIsTextEmpty;
    FlabelTextAnimation.StopAtCurrent;
    FlabelTextAnimation.Inverse := FIsTextEmpty;
    if FIsTextEmpty then FlabelTextAnimation.Duration := 0.1
    else FlabelTextAnimation.Duration := 0.2;
    FLabelTextAnimation.Start;
    repaint;
  end
  else
    FIsTextEmpty := LIsTextEmpty;
  if assigned(fOnChangeTracking) then
    fOnChangeTracking(self);
end;

{*************************************************}
procedure TALBaseEdit.OnReturnKeyImpl(Sender: TObject);
begin
  {$IF defined(DEBUG)}
  if (csLoading in componentState) then raise Exception.Create('Error B1A3CE09-A6C4-44F5-92D1-E32112A7AAE2');
  {$ENDIF}
  if assigned(fOnReturnKey) then
    fOnReturnKey(self);
end;

{**********************************************************}
procedure TALBaseEdit.SetOnReturnKey(const Value: TNotifyEvent);
begin
  fOnReturnKey := Value;
  if assigned(fOnReturnKey) then EditControl.onReturnKey := OnReturnKeyImpl
  else EditControl.onReturnKey := nil;
end;

{*********************************************}
procedure TALBaseEdit.OnEnterImpl(Sender: TObject);
begin
  {$IF defined(DEBUG)}
  if (csLoading in componentState) then raise Exception.Create('Error 7438D305-07BC-4CD9-80E3-4E0FCAA8D446');
  {$ENDIF}
  if assigned(fOnEnter) then
    fOnEnter(self);
end;

{********************************************}
procedure TALBaseEdit.OnExitImpl(Sender: TObject);
begin
  {$IF defined(DEBUG)}
  if (csLoading in componentState) then raise Exception.Create('Error B36DA0AF-D894-466B-85ED-BD1D7A85627D');
  {$ENDIF}
  if assigned(fOnExit) then
    fOnExit(self);
end;

{*******************************}
procedure TALBaseEdit.EnabledChanged;
begin
  Inherited;
  if (csLoading in componentState) then exit;
  UpdateEditControlStyle;
  UpdateNativeViewVisibility;
end;

{*******************************}
procedure TALBaseEdit.PaddingChanged;
begin
  Inherited;
  clearBufDrawable;
  AdjustSize;
end;

{***********************************************}
procedure TALBaseEdit.StrokeChanged(Sender: TObject);
begin
  inherited;
  AdjustSize;
end;

{**********************************************}
procedure TALBaseEdit.SetSides(const Value: TSides);
begin
  inherited;
  AdjustSize;
end;

{*********************************************}
procedure TALBaseEdit.FillChanged(Sender: TObject);
begin
  inherited;
  UpdateEditControlStyle;
end;

{**************************}
procedure TALBaseEdit.DoResized;
begin
  inherited;
  AdjustSize;
end;

{********************************************}
Procedure TALBaseEdit.CreateBufPromptTextDrawable(
            var ABufDrawable: TALDrawable;
            var ABufDrawableRect: TRectF;
            const AText: String;
            const AFont: TALFont);
begin

  if (not ALIsDrawableNull(ABufDrawable)) then exit;

  var LMaxSize := TSizeF.Create(Width-padding.Left-padding.Right, 65535);

  //init ABufDrawableRect
  ABufDrawableRect := TRectF.Create(0, 0, LMaxSize.cX, LMaxSize.cY);

  //create LOptions
  var LOptions := TALMultiLineTextOptions.Create;
  Try

    LOptions.Scale := ALGetScreenScale;
    //--
    LOptions.FontFamily := Afont.Family;
    LOptions.FontSize := Afont.Size;
    LOptions.FontWeight := Afont.Weight;
    LOptions.FontSlant := Afont.Slant;
    LOptions.FontStretch := Afont.Stretch;
    LOptions.FontColor := AFont.Color;
    //--
    //LOptions.DecorationKinds := ADecoration.Kinds;
    //LOptions.DecorationStyle := ADecoration.Style;
    //LOptions.DecorationThicknessMultiplier := ADecoration.ThicknessMultiplier;
    //LOptions.DecorationColor := ADecoration.Color;
    //--
    //LOptions.EllipsisText := TextSettings.Ellipsis;
    //LOptions.EllipsisInheritSettings := TextSettings.EllipsisSettings.inherit;
    //--
    //LOptions.EllipsisFontFamily := AEllipsisfont.Family;
    //LOptions.EllipsisFontSize := AEllipsisfont.Size;
    //LOptions.EllipsisFontWeight := AEllipsisfont.Weight;
    //LOptions.EllipsisFontSlant := AEllipsisfont.Slant;
    //LOptions.EllipsisFontStretch := AEllipsisfont.Stretch;
    //LOptions.EllipsisFontColor := AEllipsisFont.Color;
    //--
    //LOptions.EllipsisDecorationKinds := AEllipsisDecoration.Kinds;
    //LOptions.EllipsisDecorationStyle := AEllipsisDecoration.Style;
    //LOptions.EllipsisDecorationThicknessMultiplier := AEllipsisDecoration.ThicknessMultiplier;
    //LOptions.EllipsisDecorationColor := AEllipsisDecoration.Color;
    //--
    LOptions.AutoSize := True;
    //--
    LOptions.MaxLines := 1;
    //LOptions.LineHeightMultiplier := TextSettings.LineHeightMultiplier;
    //LOptions.LetterSpacing := TextSettings.LetterSpacing;
    //LOptions.Trimming := TextSettings.Trimming;
    //LOptions.FailIfTextBroken: boolean; // default = false
    //--
    if TFillTextFlag.RightToLeft in FillTextFlags then LOptions.Direction := TALTextDirection.RightToLeft
    else LOptions.Direction := TALTextDirection.LeftToRight;
    //LOptions.HTextAlign := TextSettings.HorzAlign;
    //LOptions.VTextAlign := TextSettings.VertAlign;
    //--
    //LOptions.FillColor: TAlphaColor; // default = TAlphaColors.null
    //LOptions.FillGradientStyle: TGradientStyle; // Default = TGradientStyle.Linear;
    //LOptions.FillGradientColors: TArray<TAlphaColor>; // Default = [];
    //LOptions.FillGradientOffsets: TArray<Single>; // Default = [];
    //LOptions.FillGradientAngle: Single; // Default = 180;
    //LOptions.FillResourceName: String; // default = ''
    //LOptions.FillWrapMode: TALImageWrapMode; // default = TALImageWrapMode.Fit
    //LOptions.FillPaddingRect: TRectF; // default = TRectF.Empty
    //LOptions.StrokeColor: TalphaColor; // default = TAlphaColors.null
    //LOptions.StrokeThickness: Single; // default = 1
    //LOptions.ShadowColor: TAlphaColor; // default = TAlphaColors.null
    //LOptions.ShadowBlur: Single; // default = 12
    //LOptions.ShadowOffsetX: Single; // default = 0
    //LOptions.ShadowOffsetY: Single; // default = 0
    //--
    //LOptions.Sides := Sides;
    //LOptions.XRadius := XRadius;
    //LOptions.YRadius := YRadius;
    //LOptions.Corners := Corners;
    //LOptions.Padding := padding.Rect;
    //--
    //LOptions.TextIsHtml := TextSettings.IsHtml;
    //--
    //LOptions.OnAdjustRect: TALMultiLineTextAdjustRectProc; // default = nil

    //build ABufDrawable
    var LTextBroken: Boolean;
    var LAllTextDrawn: Boolean;
    var LElements: TALTextElements;
    ABufDrawable := ALCreateMultiLineTextDrawable(
                      AText,
                      ABufDrawableRect,
                      LTextBroken,
                      LAllTextDrawn,
                      LElements,
                      LOptions);

    //Special case where it's impossible to draw at least one char.
    //To avoid to call again ALDrawMultiLineText on each paint
    //return a "blank" drawable.
    if (ALIsDrawableNull(ABufDrawable)) then begin
      ABufDrawableRect := TrectF.Create(0,0,1,1);
      ABufDrawableRect := ALAlignDimensionToPixelRound(ABufDrawableRect, ALGetScreenScale);
      var LSurface: TALSurface;
      var LCanvas: TALCanvas;
      ALCreateSurface(
        LSurface, // out ASurface: sk_surface_t;
        LCanvas, // out ACanvas: sk_canvas_t;
        ALGetScreenScale, // const AScale: Single;
        ABufDrawableRect.Width, // const w: integer;
        ABufDrawableRect.height);// const h: integer)
      try
        ABufDrawable := ALSurfaceToDrawable(LSurface);
      finally
        ALFreeSurface(LSurface, LCanvas);
      end;
    end;

  finally
    ALFreeAndNil(LOptions);
  end;

end;

{*******************************************}
Procedure TALBaseEdit.CreateBufLabelTextDrawable(
            var ABufDrawable: TALDrawable;
            var ABufDrawableRect: TRectF;
            const AText: String;
            const AFont: TALFont);
begin

  if (not ALIsDrawableNull(ABufDrawable)) then exit;

  var LMaxSize := TSizeF.Create(Width-padding.Left-padding.right-LabelTextSettings.Margins.Left-LabelTextSettings.Margins.right, 65535);

  //init ABufDrawableRect
  ABufDrawableRect := TRectF.Create(0, 0, LMaxSize.cX, LMaxSize.cY);

  //create LOptions
  var LOptions := TALMultiLineTextOptions.Create;
  Try

    LOptions.Scale := ALGetScreenScale;
    //--
    LOptions.FontFamily := Afont.Family;
    LOptions.FontSize := Afont.Size;
    LOptions.FontWeight := Afont.Weight;
    LOptions.FontSlant := Afont.Slant;
    LOptions.FontStretch := Afont.Stretch;
    LOptions.FontColor := AFont.Color;
    //--
    //LOptions.DecorationKinds := ADecoration.Kinds;
    //LOptions.DecorationStyle := ADecoration.Style;
    //LOptions.DecorationThicknessMultiplier := ADecoration.ThicknessMultiplier;
    //LOptions.DecorationColor := ADecoration.Color;
    //--
    LOptions.EllipsisText := LabelTextSettings.Ellipsis;
    //LOptions.EllipsisInheritSettings := LabelTextSettings.EllipsisSettings.inherit;
    //--
    //LOptions.EllipsisFontFamily := AEllipsisfont.Family;
    //LOptions.EllipsisFontSize := AEllipsisfont.Size;
    //LOptions.EllipsisFontWeight := AEllipsisfont.Weight;
    //LOptions.EllipsisFontSlant := AEllipsisfont.Slant;
    //LOptions.EllipsisFontStretch := AEllipsisfont.Stretch;
    //LOptions.EllipsisFontColor := AEllipsisFont.Color;
    //--
    //LOptions.EllipsisDecorationKinds := AEllipsisDecoration.Kinds;
    //LOptions.EllipsisDecorationStyle := AEllipsisDecoration.Style;
    //LOptions.EllipsisDecorationThicknessMultiplier := AEllipsisDecoration.ThicknessMultiplier;
    //LOptions.EllipsisDecorationColor := AEllipsisDecoration.Color;
    //--
    LOptions.AutoSize := True;
    //--
    LOptions.MaxLines := LabelTextSettings.MaxLines;
    LOptions.LineHeightMultiplier := LabelTextSettings.LineHeightMultiplier;
    LOptions.LetterSpacing := LabelTextSettings.LetterSpacing;
    LOptions.Trimming := LabelTextSettings.Trimming;
    //LOptions.FailIfTextBroken: boolean; // default = false
    //--
    if TFillTextFlag.RightToLeft in FillTextFlags then LOptions.Direction := TALTextDirection.RightToLeft
    else LOptions.Direction := TALTextDirection.LeftToRight;
    //LOptions.HTextAlign := LabelTextSettings.HorzAlign;
    //LOptions.VTextAlign := LabelTextSettings.VertAlign;
    //--
    //LOptions.FillColor: TAlphaColor; // default = TAlphaColors.null
    //LOptions.FillGradientStyle: TGradientStyle; // Default = TGradientStyle.Linear;
    //LOptions.FillGradientColors: TArray<TAlphaColor>; // Default = [];
    //LOptions.FillGradientOffsets: TArray<Single>; // Default = [];
    //LOptions.FillGradientAngle: Single; // Default = 180;
    //LOptions.FillResourceName: String; // default = ''
    //LOptions.FillWrapMode: TALImageWrapMode; // default = TALImageWrapMode.Fit
    //LOptions.FillPaddingRect: TRectF; // default = TRectF.Empty
    //LOptions.StrokeColor: TalphaColor; // default = TAlphaColors.null
    //LOptions.StrokeThickness: Single; // default = 1
    //LOptions.ShadowColor: TAlphaColor; // default = TAlphaColors.null
    //LOptions.ShadowBlur: Single; // default = 12
    //LOptions.ShadowOffsetX: Single; // default = 0
    //LOptions.ShadowOffsetY: Single; // default = 0
    //--
    //LOptions.Sides := Sides;
    //LOptions.XRadius := XRadius;
    //LOptions.YRadius := YRadius;
    //LOptions.Corners := Corners;
    //LOptions.Padding := padding.Rect;
    //--
    LOptions.TextIsHtml := LabelTextSettings.IsHtml;
    //--
    //LOptions.OnAdjustRect: TALMultiLineTextAdjustRectProc; // default = nil

    //build ABufDrawable
    var LTextBroken: Boolean;
    var LAllTextDrawn: Boolean;
    var LElements: TALTextElements;
    ABufDrawable := ALCreateMultiLineTextDrawable(
                      AText,
                      ABufDrawableRect,
                      LTextBroken,
                      LAllTextDrawn,
                      LElements,
                      LOptions);

    //Special case where it's impossible to draw at least one char.
    //To avoid to call again ALDrawMultiLineText on each paint
    //return a "blank" drawable. 
    if (ALIsDrawableNull(ABufDrawable)) then begin
      ABufDrawableRect := TrectF.Create(0,0,1,1);
      ABufDrawableRect := ALAlignDimensionToPixelRound(ABufDrawableRect, ALGetScreenScale);
      var LSurface: TALSurface;
      var LCanvas: TALCanvas;
      ALCreateSurface(
        LSurface, // out ASurface: sk_surface_t;
        LCanvas, // out ACanvas: sk_canvas_t;
        ALGetScreenScale, // const AScale: Single;
        ABufDrawableRect.Width, // const w: integer;
        ABufDrawableRect.height);// const h: integer)
      try
        ABufDrawable := ALSurfaceToDrawable(LSurface);
      finally
        ALFreeSurface(LSurface, LCanvas);
      end;
    end;

  finally
    ALFreeAndNil(LOptions);
  end;

end;

{************************************************}
Procedure TALBaseEdit.CreateBufSupportingTextDrawable(
            var ABufDrawable: TALDrawable;
            var ABufDrawableRect: TRectF;
            const AText: String;
            const AFont: TALFont);
begin

  if (not ALIsDrawableNull(ABufDrawable)) then exit;

  var LMaxSize := TSizeF.Create(Width-padding.Left-padding.right-SupportingTextSettings.Margins.Left-SupportingTextSettings.Margins.right, 65535);

  //init ABufDrawableRect
  ABufDrawableRect := TRectF.Create(0, 0, LMaxSize.cX, LMaxSize.cY);

  //create LOptions
  var LOptions := TALMultiLineTextOptions.Create;
  Try

    LOptions.Scale := ALGetScreenScale;
    //--
    LOptions.FontFamily := Afont.Family;
    LOptions.FontSize := Afont.Size;
    LOptions.FontWeight := Afont.Weight;
    LOptions.FontSlant := Afont.Slant;
    LOptions.FontStretch := Afont.Stretch;
    LOptions.FontColor := AFont.Color;
    //--
    //LOptions.DecorationKinds := ADecoration.Kinds;
    //LOptions.DecorationStyle := ADecoration.Style;
    //LOptions.DecorationThicknessMultiplier := ADecoration.ThicknessMultiplier;
    //LOptions.DecorationColor := ADecoration.Color;
    //--
    LOptions.EllipsisText := SupportingTextSettings.Ellipsis;
    //LOptions.EllipsisInheritSettings := SupportingTextSettings.EllipsisSettings.inherit;
    //--
    //LOptions.EllipsisFontFamily := AEllipsisfont.Family;
    //LOptions.EllipsisFontSize := AEllipsisfont.Size;
    //LOptions.EllipsisFontWeight := AEllipsisfont.Weight;
    //LOptions.EllipsisFontSlant := AEllipsisfont.Slant;
    //LOptions.EllipsisFontStretch := AEllipsisfont.Stretch;
    //LOptions.EllipsisFontColor := AEllipsisFont.Color;
    //--
    //LOptions.EllipsisDecorationKinds := AEllipsisDecoration.Kinds;
    //LOptions.EllipsisDecorationStyle := AEllipsisDecoration.Style;
    //LOptions.EllipsisDecorationThicknessMultiplier := AEllipsisDecoration.ThicknessMultiplier;
    //LOptions.EllipsisDecorationColor := AEllipsisDecoration.Color;
    //--
    LOptions.AutoSize := True;
    //--
    LOptions.MaxLines := SupportingTextSettings.MaxLines;
    LOptions.LineHeightMultiplier := SupportingTextSettings.LineHeightMultiplier;
    LOptions.LetterSpacing := SupportingTextSettings.LetterSpacing;
    LOptions.Trimming := SupportingTextSettings.Trimming;
    //LOptions.FailIfTextBroken: boolean; // default = false
    //--
    if TFillTextFlag.RightToLeft in FillTextFlags then LOptions.Direction := TALTextDirection.RightToLeft
    else LOptions.Direction := TALTextDirection.LeftToRight;
    //LOptions.HTextAlign := SupportingTextSettings.HorzAlign;
    //LOptions.VTextAlign := SupportingTextSettings.VertAlign;
    //--
    //LOptions.FillColor: TAlphaColor; // default = TAlphaColors.null
    //LOptions.FillGradientStyle: TGradientStyle; // Default = TGradientStyle.Linear;
    //LOptions.FillGradientColors: TArray<TAlphaColor>; // Default = [];
    //LOptions.FillGradientOffsets: TArray<Single>; // Default = [];
    //LOptions.FillGradientAngle: Single; // Default = 180;
    //LOptions.FillResourceName: String; // default = ''
    //LOptions.FillWrapMode: TALImageWrapMode; // default = TALImageWrapMode.Fit
    //LOptions.FillPaddingRect: TRectF; // default = TRectF.Empty
    //LOptions.StrokeColor: TalphaColor; // default = TAlphaColors.null
    //LOptions.StrokeThickness: Single; // default = 1
    //LOptions.ShadowColor: TAlphaColor; // default = TAlphaColors.null
    //LOptions.ShadowBlur: Single; // default = 12
    //LOptions.ShadowOffsetX: Single; // default = 0
    //LOptions.ShadowOffsetY: Single; // default = 0
    //--
    //LOptions.Sides := Sides;
    //LOptions.XRadius := XRadius;
    //LOptions.YRadius := YRadius;
    //LOptions.Corners := Corners;
    //LOptions.Padding := padding.Rect;
    //--
    LOptions.TextIsHtml := SupportingTextSettings.IsHtml;
    //--
    //LOptions.OnAdjustRect: TALMultiLineTextAdjustRectProc; // default = nil

    //build ABufDrawable
    var LTextBroken: Boolean;
    var LAllTextDrawn: Boolean;
    var LElements: TALTextElements;
    ABufDrawable := ALCreateMultiLineTextDrawable(
                      AText,
                      ABufDrawableRect,
                      LTextBroken,
                      LAllTextDrawn,
                      LElements,
                      LOptions);

    //Special case where it's impossible to draw at least one char.
    //To avoid to call again ALDrawMultiLineText on each paint
    //return a "blank" drawable.
    if (ALIsDrawableNull(ABufDrawable)) then begin
      ABufDrawableRect := TrectF.Create(0,0,1,1);
      ABufDrawableRect := ALAlignDimensionToPixelRound(ABufDrawableRect, ALGetScreenScale);
      var LSurface: TALSurface;
      var LCanvas: TALCanvas;
      ALCreateSurface(
        LSurface, // out ASurface: sk_surface_t;
        LCanvas, // out ACanvas: sk_canvas_t;
        ALGetScreenScale, // const AScale: Single;
        ABufDrawableRect.Width, // const w: integer;
        ABufDrawableRect.height);// const h: integer)
      try
        ABufDrawable := ALSurfaceToDrawable(LSurface);
      finally
        ALFreeSurface(LSurface, LCanvas);
      end;
    end;

  finally
    ALFreeAndNil(LOptions);
  end;

end;

{********************************}
procedure TALBaseEdit.MakeBufDrawable;

  {~~~~~~~~~~~~~~~~~~~~~~~~~}
  procedure _MakeBufDrawable(
              const AStateStyle: TALEditBaseStateStyle;
              var ABufDrawable: TALDrawable;
              var ABufDrawableRect: TRectF);
  begin
    if AStateStyle.Fill.Inherit and
       AStateStyle.Stroke.Inherit and
       AStateStyle.Shadow.Inherit then exit;
    if (not ALIsDrawableNull(ABufDrawable)) then exit;
    AStateStyle.Fill.Supersede;
    AStateStyle.Stroke.Supersede;
    AStateStyle.Shadow.Supersede;
    try
      CreateBufDrawable(
        ABufDrawable, // var ABufDrawable: TALDrawable;
        ABufDrawableRect, // var ABufDrawableRect: TRectF;
        AStateStyle.Fill, // const AFill: TALBrush;
        AStateStyle.Stroke, // const AStroke: TALStrokeBrush;
        AStateStyle.Shadow); // const AShadow: TALShadow);
    finally
      AStateStyle.Fill.Reinstate;
      AStateStyle.Stroke.Reinstate;
      AStateStyle.Shadow.Reinstate;
    end;
  end;

begin
  inherited MakeBufDrawable;
  //--
  MakeBufPromptTextDrawable;
  MakeBufLabelTextDrawable;
  MakeBufSupportingTextDrawable;
  //--
  if (Size.Size.IsZero) then begin // Do not create BufDrawable if the size is 0
    clearBufDrawable;
    exit;
  end;
  //--
  if Not Enabled then begin
    _MakeBufDrawable(
      StateStyles.Disabled, // const AStateStyle: TALButtonStateStyle;
      FBufDisabledDrawable, // var ABufDrawable: TALDrawable;
      FBufDisabledDrawableRect); // var ABufDrawableRect: TRectF;
  end
  else if IsFocused then begin
    _MakeBufDrawable(
      StateStyles.Focused, // const AStateStyle: TALButtonStateStyle;
      FBufFocusedDrawable, // var ABufDrawable: TALDrawable;
      FBufFocusedDrawableRect); // var ABufDrawableRect: TRectF;
  end
  else if FHovered then begin
    _MakeBufDrawable(
      StateStyles.Hovered, // const AStateStyle: TALButtonStateStyle;
      FBufHoveredDrawable, // var ABufDrawable: TALDrawable;
      FBufHoveredDrawableRect); // var ABufDrawableRect: TRectF;
  end;
end;

{*****************************************}
procedure TALBaseEdit.MakeBufPromptTextDrawable;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  procedure _MakeBufPromptTextDrawable(
              const APromptText: String;
              const AStateStyle: TALEditBaseStateStyle;
              const AUsePromptTextColor: Boolean;
              var ABufPromptTextDrawable: TALDrawable;
              var ABufPromptTextDrawableRect: TRectF);
  begin
    if (AStateStyle.TextSettings.Inherit) and
       ((not AUsePromptTextColor) or (AStateStyle.PromptTextColor = TalphaColors.Null)) then exit;
    if (not ALIsDrawableNull(ABufPromptTextDrawable)) then exit;
    AStateStyle.Supersede;
    try
      var LPrevFontColor := AStateStyle.TextSettings.font.Color;
      var LPrevFontOnchanged: TNotifyEvent;
      LPrevFontOnchanged := AStateStyle.TextSettings.OnChanged;
      AStateStyle.TextSettings.OnChanged := nil;
      try
        if AUsePromptTextColor then begin
          if AStateStyle.PromptTextColor <> TAlphaColors.Null then AStateStyle.TextSettings.Font.Color := AStateStyle.PromptTextColor
          else if PromptTextColor <> TalphaColors.Null then AStateStyle.TextSettings.Font.Color := PromptTextColor
          else AStateStyle.TextSettings.Font.Color := TAlphaColorF.Create(
                                                        ALSetColorOpacity(TextSettings.Font.Color, 0.5)).
                                                          PremultipliedAlpha.
                                                          ToAlphaColor;
        end;
        CreateBufPromptTextDrawable(
          ABufPromptTextDrawable, // var ABufPromptTextDrawable: TALDrawable;
          ABufPromptTextDrawableRect, // var ABufPromptTextDrawableRect: TRectF;
          APromptText, // const AText: String;
          AStateStyle.TextSettings.font); // const AFont: TALFont;
      finally
        AStateStyle.TextSettings.font.Color := LPrevFontColor;
        AStateStyle.TextSettings.OnChanged := LPrevFontOnchanged;
      end;
    finally
      AStateStyle.Reinstate;
    end;
  end;

begin
  Var LPromptText: String;
  var LUsePromptTextColor: Boolean;
  if (not Enabled) or
     (GetIsTextEmpty and HasTranslationLabelTextAnimation)
     {$IF defined(ALDPK)}or true{$ENDIF} then begin
    LPromptText := GetText;
    LUsePromptTextColor := False;
    if LPromptText = '' then begin
      LUsePromptTextColor := True;
      LPromptText := PromptText;
      if LPromptText = '' then LPromptText := LabelText;
    end
    else if Password then
      LPromptText := StringOfChar('*', Length(LPromptText));
  end
  else begin
    LPromptText := '';
    LUsePromptTextColor := True;
  end;

  if (LPromptText = '') or // Do not create BufPromptTextDrawable if LPromptText is empty
     (Size.Size.IsZero) then begin // Do not create BufPromptTextDrawable if the size is 0
    clearBufPromptTextDrawable;
    exit;
  end;
  //--
  if ALIsDrawableNull(FBufPromptTextDrawable) then begin
    var LFont := TextSettings.Font;
    var LPrevFontColor := LFont.Color;
    var LPrevFontOnchanged: TNotifyEvent := LFont.OnChanged;
    LFont.OnChanged := nil;
    if LUsePromptTextColor then begin
      if PromptTextColor <> TalphaColors.Null then LFont.Color := PromptTextColor
      else LFont.Color := TAlphaColorF.Create(
                            ALSetColorOpacity(TextSettings.Font.Color, 0.5)).
                              PremultipliedAlpha.
                              ToAlphaColor;
    end;
    try
      CreateBufPromptTextDrawable(
        FBufPromptTextDrawable, // var ABufPromptTextDrawable: TALDrawable;
        FBufPromptTextDrawableRect, // var ABufPromptTextDrawableRect: TRectF;
        LPromptText, // const AText: String;
        Lfont); // const AFont: TALFont;
    finally
      Lfont.Color := LPrevFontColor;
      LFont.OnChanged := LPrevFontOnchanged;
    end;
  end;
  //--
  if Not Enabled then begin
    _MakeBufPromptTextDrawable(
      LPromptText, // const APromptText: String;
      StateStyles.Disabled, // const AStateStyle: TALButtonStateStyle;
      LUsePromptTextColor, // const AUsePromptTextColor: Boolean;
      FBufPromptTextDisabledDrawable, // var ABufPromptTextDrawable: TALDrawable;
      FBufPromptTextDisabledDrawableRect); // var ABufPromptTextDrawableRect: TRectF;
  end
  else if IsFocused then begin
    _MakeBufPromptTextDrawable(
      LPromptText, // const APromptText: String;
      StateStyles.Focused, // const AStateStyle: TALButtonStateStyle;
      LUsePromptTextColor, // const AUsePromptTextColor: Boolean;
      FBufPromptTextFocusedDrawable, // var ABufPromptTextDrawable: TALDrawable;
      FBufPromptTextFocusedDrawableRect); // var ABufPromptTextDrawableRect: TRectF;
  end
  else if FHovered then begin
    _MakeBufPromptTextDrawable(
      LPromptText, // const APromptText: String;
      StateStyles.Hovered, // const AStateStyle: TALButtonStateStyle;
      LUsePromptTextColor, // const AUsePromptTextColor: Boolean;
      FBufPromptTextHoveredDrawable, // var ABufPromptTextDrawable: TALDrawable;
      FBufPromptTextHoveredDrawableRect); // var ABufPromptTextDrawableRect: TRectF;
  end;
end;

{*****************************************}
procedure TALBaseEdit.MakeBufLabelTextDrawable;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  procedure _MakeBufLabelTextDrawable(
              const AStateStyle: TALEditBaseStateStyle;
              var ABufLabelTextDrawable: TALDrawable;
              var ABufLabelTextDrawableRect: TRectF);
  begin
    if AStateStyle.LabelTextSettings.Inherit then exit;
    if (not ALIsDrawableNull(ABufLabelTextDrawable)) then exit;
    AStateStyle.LabelTextSettings.Supersede;
    try
      CreateBufLabelTextDrawable(
        ABufLabelTextDrawable, // var ABufLabelTextDrawable: TALDrawable;
        ABufLabelTextDrawableRect, // var ABufLabelTextDrawableRect: TRectF;
        FLabelText, // const AText: String;
        AStateStyle.LabelTextSettings.font); // const AFont: TALFont;
    finally
      AStateStyle.LabelTextSettings.Reinstate;
    end;
  end;

begin
  if (FLabelText = '') or // Do not create BufLabelTextDrawable if LPromptText is empty
     (Size.Size.IsZero) then begin // Do not create BufLabelTextDrawable if the size is 0
    clearBufLabelTextDrawable;
    exit;
  end;
  //--
  if ALIsDrawableNull(FBufLabelTextDrawable) then begin
    CreateBufLabelTextDrawable(
      FBufLabelTextDrawable, // var ABufLabelTextDrawable: TALDrawable;
      FBufLabelTextDrawableRect, // var ABufLabelTextDrawableRect: TRectF;
      FLabelText, // const AText: String;
      LabelTextSettings.font); // const AFont: TALFont;
  end;
  //--
  if Not Enabled then begin
    _MakeBufLabelTextDrawable(
      StateStyles.Disabled, // const AStateStyle: TALButtonStateStyle;
      FBufLabelTextDisabledDrawable, // var ABufLabelTextDrawable: TALDrawable;
      FBufLabelTextDisabledDrawableRect); // var ABufLabelTextDrawableRect: TRectF;
  end
  else if IsFocused then begin
    _MakeBufLabelTextDrawable(
      StateStyles.Focused, // const AStateStyle: TALButtonStateStyle;
      FBufLabelTextFocusedDrawable, // var ABufLabelTextDrawable: TALDrawable;
      FBufLabelTextFocusedDrawableRect); // var ABufLabelTextDrawableRect: TRectF;
  end
  else if FHovered then begin
    _MakeBufLabelTextDrawable(
      StateStyles.Hovered, // const AStateStyle: TALButtonStateStyle;
      FBufLabelTextHoveredDrawable, // var ABufLabelTextDrawable: TALDrawable;
      FBufLabelTextHoveredDrawableRect); // var ABufLabelTextDrawableRect: TRectF;
  end;
end;

{*********************************}
procedure TALBaseEdit.MakeBufSupportingTextDrawable;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  procedure _MakeBufSupportingTextDrawable(
              const AStateStyle: TALEditBaseStateStyle;
              var ABufSupportingTextDrawable: TALDrawable;
              var ABufSupportingTextDrawableRect: TRectF);
  begin
    if AStateStyle.SupportingTextSettings.Inherit then exit;
    if (not ALIsDrawableNull(ABufSupportingTextDrawable)) then exit;
    AStateStyle.SupportingTextSettings.Supersede;
    try
      CreateBufSupportingTextDrawable(
        ABufSupportingTextDrawable, // var ABufSupportingTextDrawable: TALDrawable;
        ABufSupportingTextDrawableRect, // var ABufSupportingTextDrawableRect: TRectF;
        FSupportingText, // const AText: String;
        AStateStyle.SupportingTextSettings.font); // const AFont: TALFont;
      ABufSupportingTextDrawableRect.SetLocation(
        padding.Left + SupportingTextSettings.Margins.Left,
        Height+SupportingTextSettings.Margins.Top);
    finally
      AStateStyle.SupportingTextSettings.Reinstate;
    end;
  end;

begin
  if (FSupportingText = '') or // Do not create BufSupportingTextDrawable if LPromptText is empty
     (Size.Size.IsZero) then begin // Do not create BufSupportingTextDrawable if the size is 0
    clearBufSupportingTextDrawable;
    exit;
  end;
  //--
  if ALIsDrawableNull(FBufSupportingTextDrawable) then begin
    CreateBufSupportingTextDrawable(
      FBufSupportingTextDrawable, // var ABufSupportingTextDrawable: TALDrawable;
      FBufSupportingTextDrawableRect, // var ABufSupportingTextDrawableRect: TRectF;
      FSupportingText, // const AText: String;
      SupportingTextSettings.font); // const AFont: TALFont;
    FBufSupportingTextDrawableRect.SetLocation(
      padding.Left + SupportingTextSettings.Margins.Left,
      Height+SupportingTextSettings.Margins.Top);
    if (SupportingTextSettings.Layout = TALEditSupportingTextLayout.Inline) then begin
      {$IF defined(debug)}
      if FSupportingTextMarginBottomUpdated then
        Raise exception.Create('Error #7F39617E-617D-4A1E-A383-22E34B42AE1E');
      {$ENDIF}
      FSupportingTextMarginBottomUpdated := True;
      Margins.Bottom := FBufSupportingTextDrawableRect.Height + SupportingTextSettings.Margins.Top + SupportingTextSettings.Margins.bottom;
    end;
  end;
  //--
  if Not Enabled then begin
    _MakeBufSupportingTextDrawable(
      StateStyles.Disabled, // const AStateStyle: TALButtonStateStyle;
      FBufSupportingTextDisabledDrawable, // var ABufSupportingTextDrawable: TALDrawable;
      FBufSupportingTextDisabledDrawableRect); // var ABufSupportingTextDrawableRect: TRectF;
  end
  else if IsFocused then begin
    _MakeBufSupportingTextDrawable(
      StateStyles.Focused, // const AStateStyle: TALButtonStateStyle;
      FBufSupportingTextFocusedDrawable, // var ABufSupportingTextDrawable: TALDrawable;
      FBufSupportingTextFocusedDrawableRect); // var ABufSupportingTextDrawableRect: TRectF;
  end
  else if FHovered then begin
    _MakeBufSupportingTextDrawable(
      StateStyles.Hovered, // const AStateStyle: TALButtonStateStyle;
      FBufSupportingTextHoveredDrawable, // var ABufSupportingTextDrawable: TALDrawable;
      FBufSupportingTextHoveredDrawableRect); // var ABufSupportingTextDrawableRect: TRectF;
  end;
end;

{*********************************}
procedure TALBaseEdit.clearBufDrawable;
begin
  {$IFDEF debug}
  if (not (csDestroying in ComponentState)) and
     (ALIsDrawableNull(BufDrawable)) and // warn will be raise in inherited
     ((not ALIsDrawableNull(fBufDisabledDrawable)) or
      (not ALIsDrawableNull(fBufHoveredDrawable)) or
      (not ALIsDrawableNull(fBufFocusedDrawable))) then
    ALLog(Classname + '.clearBufDrawable', 'BufDrawable has been cleared | Name: ' + Name, TalLogType.warn);
  {$endif}
  inherited clearBufDrawable;
  //--
  ALFreeAndNilDrawable(fBufDisabledDrawable);
  ALFreeAndNilDrawable(fBufHoveredDrawable);
  ALFreeAndNilDrawable(fBufFocusedDrawable);
  //--
  clearBufPromptTextDrawable;
  clearBufLabelTextDrawable;
  clearBufSupportingTextDrawable;
end;

{*********************************}
procedure TALBaseEdit.clearBufPromptTextDrawable;
begin
  ALFreeAndNilDrawable(fBufPromptTextDrawable);
  ALFreeAndNilDrawable(fBufPromptTextDisabledDrawable);
  ALFreeAndNilDrawable(fBufPromptTextHoveredDrawable);
  ALFreeAndNilDrawable(fBufPromptTextFocusedDrawable);
end;

{*********************************}
procedure TALBaseEdit.clearBufLabelTextDrawable;
begin
  ALFreeAndNilDrawable(fBufLabelTextDrawable);
  ALFreeAndNilDrawable(fBufLabelTextDisabledDrawable);
  ALFreeAndNilDrawable(fBufLabelTextHoveredDrawable);
  ALFreeAndNilDrawable(fBufLabelTextFocusedDrawable);
end;

{*********************************}
procedure TALBaseEdit.clearBufSupportingTextDrawable;
begin
  if (FSupportingTextMarginBottomUpdated) and
     (not ALIsDrawableNull(fBufSupportingTextDrawable)) and
     (not (csDestroying in ComponentState)) then begin
    FSupportingTextMarginBottomUpdated := False;
    Margins.Bottom := FSupportingTextSettings.Margins.Bottom;
  end;
  ALFreeAndNilDrawable(fBufSupportingTextDrawable);
  ALFreeAndNilDrawable(fBufSupportingTextDisabledDrawable);
  ALFreeAndNilDrawable(fBufSupportingTextHoveredDrawable);
  ALFreeAndNilDrawable(fBufSupportingTextFocusedDrawable);
end;

{**********************}
procedure TALBaseEdit.Paint;
begin

  MakeBufDrawable;

  {$REGION 'Background'}
  var LDrawable: TALDrawable;
  var LDrawableRect: TRectF;
  if Not Enabled then begin
    LDrawable := fBufDisabledDrawable;
    LDrawableRect := fBufDisabledDrawableRect;
    if ALIsDrawableNull(LDrawable) then begin
      LDrawable := BufDrawable;
      LDrawableRect := BufDrawableRect;
    end;
  end
  //--
  else if IsFocused then begin
    LDrawable := fBufFocusedDrawable;
    LDrawableRect := fBufFocusedDrawableRect;
    if ALIsDrawableNull(LDrawable) then begin
      LDrawable := BufDrawable;
      LDrawableRect := BufDrawableRect;
    end;
  end
  //--
  else if FHovered then begin
    LDrawable := fBufHoveredDrawable;
    LDrawableRect := fBufHoveredDrawableRect;
    if ALIsDrawableNull(LDrawable) then begin
      LDrawable := BufDrawable;
      LDrawableRect := BufDrawableRect;
    end;
  end
  //--
  else begin
    LDrawable := BufDrawable;
    LDrawableRect := BufDrawableRect;
  end;
  //--
  if ALIsDrawableNull(LDrawable) then inherited Paint
  else
    ALDrawDrawable(
      Canvas, // const ACanvas: Tcanvas;
      LDrawable, // const ADrawable: TALDrawable;
      LDrawableRect.TopLeft, // const ATopLeft: TpointF;
      AbsoluteOpacity); // const AOpacity: Single);
  {$ENDREGION}

  {$REGION 'LabelText'}
  var LLabelTextDrawable: TALDrawable;
  var LLabelTextDrawableRect: TRectF;
  if Not Enabled then begin
    LLabelTextDrawable := fBufLabelTextDisabledDrawable;
    LLabelTextDrawableRect := fBufLabelTextDisabledDrawableRect;
    if ALIsDrawableNull(LLabelTextDrawable) then begin
      LLabelTextDrawable := FBufLabelTextDrawable;
      LLabelTextDrawableRect := FBufLabelTextDrawableRect;
    end;
  end
  //--
  else if IsFocused then begin
    LLabelTextDrawable := fBufLabelTextFocusedDrawable;
    LLabelTextDrawableRect := fBufLabelTextFocusedDrawableRect;
    if ALIsDrawableNull(LLabelTextDrawable) then begin
      LLabelTextDrawable := FBufLabelTextDrawable;
      LLabelTextDrawableRect := FBufLabelTextDrawableRect;
    end;
  end
  //--
  else if FHovered then begin
    LLabelTextDrawable := fBufLabelTextHoveredDrawable;
    LLabelTextDrawableRect := fBufLabelTextHoveredDrawableRect;
    if ALIsDrawableNull(LLabelTextDrawable) then begin
      LLabelTextDrawable := FBufLabelTextDrawable;
      LLabelTextDrawableRect := FBufLabelTextDrawableRect;
    end;
  end
  //--
  else begin
    LLabelTextDrawable := FBufLabelTextDrawable;
    LLabelTextDrawableRect := FBufLabelTextDrawableRect;
  end;
  //--
  if LabelTextSettings.Layout = TALEditLabelTextLayout.Inline then
    LLabelTextDrawableRect.SetLocation(
      EditControl.Left + LabelTextSettings.Margins.Left,
      Padding.top+FeditControl.Margins.top-LLabelTextDrawableRect.Height-LabelTextSettings.Margins.Bottom)
  else
    LLabelTextDrawableRect.SetLocation(
      padding.Left + LabelTextSettings.Margins.Left,
      0-LLabelTextDrawableRect.Height-LabelTextSettings.Margins.Bottom);
  //--
  if (GetIsTextEmpty and HasTranslationLabelTextAnimation and (hasNativeView)) or
     ((Labeltext <> '') and (prompttext <> '') and (prompttext <> labeltext)) or
     (not GetIsTextEmpty) or
     (GetIsTextEmpty and HasOpacityLabelTextAnimation and FLabelTextAnimation.Running) then begin
    if (not ALisDrawableNull(LLabelTextDrawable)) then begin
      var LRect := LLabelTextDrawableRect;
      LRect.Inflate(4{DL}, 4{DT}, 4{DR}, 4{DB});
      LRect.Intersect(LocalRect);
      if not LRect.IsEmpty then begin
        LRect := Canvas.AlignToPixel(LRect);
        Canvas.Fill.Kind := TBrushKind.Solid;
        Canvas.Fill.Color := EditControl.FillColor;
        Canvas.FillRect(LRect, ALIfThen(FLabelTextAnimation.Running, Min(1,FlabelTextAnimation.CurrentValue*2), 1));
      end;
    end;
    //--
    ALDrawDrawable(
      Canvas, // const ACanvas: Tcanvas;
      LLabelTextDrawable, // const ADrawable: TALDrawable;
      LLabelTextDrawableRect.TopLeft, // const ATopLeft: TpointF;
      ALIfThen(FLabelTextAnimation.Running, FLabelTextAnimation.CurrentValue, 1)); // const AOpacity: Single);
  end;
  {$ENDREGION}

  {$REGION 'PromptText'}
  if (not Enabled) or
     (GetIsTextEmpty and HasTranslationLabelTextAnimation and (not hasNativeView))
     {$IF defined(ALDPK)}or true{$ENDIF} then begin
    var LPromptTextDrawable: TALDrawable;
    var LPromptTextDrawableRect: TRectF;
    if Not Enabled then begin
      LPromptTextDrawable := fBufPromptTextDisabledDrawable;
      LPromptTextDrawableRect := fBufPromptTextDisabledDrawableRect;
      if ALIsDrawableNull(LPromptTextDrawable) then begin
        LPromptTextDrawable := FBufPromptTextDrawable;
        LPromptTextDrawableRect := FBufPromptTextDrawableRect;
      end;
    end
    //--
    //--
    else if IsFocused then begin
      LPromptTextDrawable := fBufPromptTextFocusedDrawable;
      LPromptTextDrawableRect := fBufPromptTextFocusedDrawableRect;
      if ALIsDrawableNull(LPromptTextDrawable) then begin
        LPromptTextDrawable := FBufPromptTextDrawable;
        LPromptTextDrawableRect := FBufPromptTextDrawableRect;
      end;
    end
    //--
    else if FHovered then begin
      LPromptTextDrawable := fBufPromptTextHoveredDrawable;
      LPromptTextDrawableRect := fBufPromptTextHoveredDrawableRect;
      if ALIsDrawableNull(LPromptTextDrawable) then begin
        LPromptTextDrawable := FBufPromptTextDrawable;
        LPromptTextDrawableRect := FBufPromptTextDrawableRect;
      end;
    end
    //--
    else begin
      LPromptTextDrawable := FBufPromptTextDrawable;
      LPromptTextDrawableRect := FBufPromptTextDrawableRect;
    end;
    //--
    Var LPos: TpointF;
    case TextSettings.HorzAlign of
      TALTextHorzAlign.Center: LPos.X := EditControl.Position.X + ((EditControl.width - LPromptTextDrawableRect.Width) / 2);
      TALTextHorzAlign.Leading: LPos.X := EditControl.Position.X;
      TALTextHorzAlign.Trailing: LPos.X := EditControl.Position.X + EditControl.Width - LPromptTextDrawableRect.Width;
      TALTextHorzAlign.Justify: LPos.X := EditControl.Position.X;
      else
        raise Exception.Create('Error EC344A62-E381-4126-A0EB-12BFC91E3664');
    end;
    if GetIsTextEmpty and (HasTranslationLabelTextAnimation) then begin
      if LabelTextSettings.Layout = TALEditLabelTextLayout.Inline then begin
        case TextSettings.VertAlign of
          TALTextVertAlign.Center: LPos.y := LLabelTextDrawableRect.Top + ((EditControl.Height + LLabelTextDrawableRect.Height + LabelTextSettings.Margins.Bottom - LPromptTextDrawableRect.Height) / 2);
          TALTextVertAlign.Leading: LPos.y := EditControl.Position.y;
          TALTextVertAlign.Trailing: LPos.y := EditControl.Position.y + EditControl.Height - LPromptTextDrawableRect.Height;
          Else
            Raise Exception.Create('Error 28B2F8BC-B4C5-4F22-8E21-681AA1CA3C23')
        end;
      end
      else if LabelTextSettings.Layout = TALEditLabelTextLayout.floating then begin
        case TextSettings.VertAlign of
          TALTextVertAlign.Center: LPos.y := EditControl.Position.y + ((EditControl.Height - LPromptTextDrawableRect.Height) / 2);
          TALTextVertAlign.Leading: LPos.y := EditControl.Position.y;
          TALTextVertAlign.Trailing: LPos.y := EditControl.Position.y + EditControl.Height - LPromptTextDrawableRect.Height;
          Else
            Raise Exception.Create('Error 28B2F8BC-B4C5-4F22-8E21-681AA1CA3C23')
        end;
      end
      else
        raise Exception.Create('Error 42442487-01E1-4810-A030-FC4904834EC2');
      LPromptTextDrawableRect.SetLocation(LPos.X, LPos.y);
      if (FLabelTextAnimation.Running) then begin
        LPromptTextDrawableRect.SetLocation(
          LPromptTextDrawableRect.Left - ((LPromptTextDrawableRect.Left - LLabelTextDrawableRect.Left) * FLabelTextAnimation.CurrentValue),
          LPromptTextDrawableRect.Top - ((LPromptTextDrawableRect.top - LLabelTextDrawableRect.top) * FLabelTextAnimation.CurrentValue));
        LPromptTextDrawableRect.Width := LPromptTextDrawableRect.width - ((LPromptTextDrawableRect.width - LLabelTextDrawableRect.Width) * FLabelTextAnimation.CurrentValue);
        LPromptTextDrawableRect.Height := LPromptTextDrawableRect.Height - ((LPromptTextDrawableRect.Height - LLabelTextDrawableRect.Height) * FLabelTextAnimation.CurrentValue);
        if (not ALisDrawableNull(LPromptTextDrawable)) then begin
          var LRect := LPromptTextDrawableRect;
          LRect.Inflate(4{DL}, 4{DT}, 4{DR}, 4{DB});
          LRect.Intersect(LocalRect);
          if not LRect.IsEmpty then begin
            LRect := Canvas.AlignToPixel(LRect);
            Canvas.Fill.Kind := TBrushKind.Solid;
            Canvas.Fill.Color := EditControl.FillColor;
            Canvas.FillRect(LRect, 1);
          end;
        end;
        ALDrawDrawable(
          Canvas, // const ACanvas: Tcanvas;
          LPromptTextDrawable, // const ADrawable: TALDrawable;
          LPromptTextDrawableRect, // const ADstRect: TrectF;
          AbsoluteOpacity); // const AOpacity: Single);
      end
      else
        ALDrawDrawable(
          Canvas, // const ACanvas: Tcanvas;
          LPromptTextDrawable, // const ADrawable: TALDrawable;
          LPromptTextDrawableRect.TopLeft, // const ATopLeft: TpointF;
          AbsoluteOpacity); // const AOpacity: Single);
    end
    else begin
      case TextSettings.VertAlign of
        TALTextVertAlign.Center: LPos.y := EditControl.Position.y + ((EditControl.Height - LPromptTextDrawableRect.Height) / 2);
        TALTextVertAlign.Leading: LPos.y := EditControl.Position.y;
        TALTextVertAlign.Trailing: LPos.y := EditControl.Position.y + EditControl.Height - LPromptTextDrawableRect.Height;
        Else
          Raise Exception.Create('Error 84D5B492-1F70-43A0-AB68-D30C70D260BC')
      end;
      LPromptTextDrawableRect.SetLocation(LPos.X, LPos.y);
      ALDrawDrawable(
        Canvas, // const ACanvas: Tcanvas;
        LPromptTextDrawable, // const ADrawable: TALDrawable;
        LPromptTextDrawableRect.TopLeft, // const ATopLeft: TpointF;
        AbsoluteOpacity); // const AOpacity: Single);
    end;
  end;
  {$ENDREGION}

  {$REGION 'SupportingText'}
  var LSupportingTextDrawable: TALDrawable;
  var LSupportingTextDrawableRect: TRectF;
  if Not Enabled then begin
    LSupportingTextDrawable := fBufSupportingTextDisabledDrawable;
    LSupportingTextDrawableRect := fBufSupportingTextDisabledDrawableRect;
    if ALIsDrawableNull(LSupportingTextDrawable) then begin
      LSupportingTextDrawable := FBufSupportingTextDrawable;
      LSupportingTextDrawableRect := FBufSupportingTextDrawableRect;
    end;
  end
  //--
  else if IsFocused then begin
    LSupportingTextDrawable := fBufSupportingTextFocusedDrawable;
    LSupportingTextDrawableRect := fBufSupportingTextFocusedDrawableRect;
    if ALIsDrawableNull(LSupportingTextDrawable) then begin
      LSupportingTextDrawable := FBufSupportingTextDrawable;
      LSupportingTextDrawableRect := FBufSupportingTextDrawableRect;
    end;
  end
  //--
  else if FHovered then begin
    LSupportingTextDrawable := fBufSupportingTextHoveredDrawable;
    LSupportingTextDrawableRect := fBufSupportingTextHoveredDrawableRect;
    if ALIsDrawableNull(LSupportingTextDrawable) then begin
      LSupportingTextDrawable := FBufSupportingTextDrawable;
      LSupportingTextDrawableRect := FBufSupportingTextDrawableRect;
    end;
  end
  //--
  else begin
    LSupportingTextDrawable := FBufSupportingTextDrawable;
    LSupportingTextDrawableRect := FBufSupportingTextDrawableRect;
  end;
  //--
  ALDrawDrawable(
    Canvas, // const ACanvas: Tcanvas;
    LSupportingTextDrawable, // const ADrawable: TALDrawable;
    LSupportingTextDrawableRect.TopLeft, // const ATopLeft: TpointF;
    AbsoluteOpacity); // const AOpacity: Single);
  {$ENDREGION}

end;

{**************************************}
function TALBaseEdit.HasNativeView: Boolean;
begin
  result := EditControl.HasNativeView;
end;

{******************************}
Procedure TALBaseEdit.AddNativeView;
begin
  FNativeViewRemoved := False;
  UpdateNativeViewVisibility;
end;

{*********************************}
Procedure TALBaseEdit.RemoveNativeView;
begin
  FNativeViewRemoved := True;
  ResetFocus;
  EditControl.RemoveNativeView;
end;

{*****************************************}
function TALBaseEdit.getLineCount: integer;
begin
  Result := EditControl.getLineCount;
end;

{*****************************************}
function TALBaseEdit.getLineHeight: single;
begin
  result := EditControl.getLineHeight;
end;

{*********************************************}
constructor TALEdit.Create(AOwner: TComponent);
begin
  inherited;
  FAutoSize := True;
end;

{*****************************************}
function TALEdit.GetAutoSize: Boolean;
begin
  result := FAutoSize;
end;

{*****************************************}
function TALEdit.HasUnconstrainedAutosizeX: Boolean;
begin
  result := False;
end;

{*****************************************}
function TALEdit.HasUnconstrainedAutosizeY: Boolean;
begin
  result := (GetAutoSize) and
            (not (Align in [TAlignLayout.Client,
                            TAlignLayout.Contents,
                            TAlignLayout.Left,
                            TAlignLayout.Right,
                            TAlignLayout.MostLeft,
                            TAlignLayout.MostRight,
                            TAlignLayout.Vertical,
                            TAlignLayout.HorzCenter]))
end;

{****************************************************}
procedure TALEdit.SetAutoSize(const Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    AdjustSize;
    repaint;
  end;
end;

{***************************}
procedure TALEdit.AdjustSize;
begin
  if (not (csLoading in ComponentState)) and // loaded will call again AdjustSize
     (not (csDestroying in ComponentState)) and // if csDestroying do not do autosize
     (TNonReentrantHelper.EnterSection(FIsAdjustingSize)) then begin // non-reantrant
    try
      Var LInlinedLabelText := (LabelText <> '') and (LabelTextSettings.Layout = TALEditLabelTextLayout.Inline);
      if LInlinedLabelText then MakeBufLabelTextDrawable;

      var LStrokeSize := TRectF.Empty;
      if Stroke.HasStroke then begin
        if (TSide.Top in Sides) then    LStrokeSize.Top :=    max(Stroke.Thickness - Padding.top,    0);
        if (TSide.bottom in Sides) then LStrokeSize.bottom := max(Stroke.Thickness - Padding.bottom, 0);
        if (TSide.right in Sides) then  LStrokeSize.right :=  max(Stroke.Thickness - Padding.right,  0);
        if (TSide.left in Sides) then   LStrokeSize.left :=   max(Stroke.Thickness - Padding.left,   0);
      end;

      if HasUnconstrainedAutosizeY then begin

        If LInlinedLabelText then begin
          SetBounds(
            Position.X,
            Position.Y,
            Width,
            GetLineHeight + LStrokeSize.Top + LStrokeSize.bottom + padding.Top + padding.Bottom + BufLabelTextDrawableRect.Height + LabelTextSettings.Margins.Top + LabelTextSettings.Margins.bottom);
        end
        else begin
          SetBounds(
            Position.X,
            Position.Y,
            Width,
            GetLineHeight + LStrokeSize.Top + LStrokeSize.bottom + padding.Top + padding.Bottom);
        end;

      end;

      var LMarginRect := TRectF.Empty;

      {$IF defined(MSWINDOWS) or defined(ALMacOS)}
      // In Windows and MacOS, there is no way to align text vertically,
      // so we must center the EditControl.
      If not LInlinedLabelText then begin
        Var LAvailableHeight := Height - LStrokeSize.Top - LStrokeSize.bottom - Padding.top - Padding.Bottom;
        var LEditControlHeight := GetLineHeight;
        {$IF defined(ALMacOS)}
        // For an obscure reason, when FocusRingType is set to NSFocusRingTypeNone and the font size
        // is not 16, focusing on the EditField causes it to shift up by 2 pixels.
        LEditControlHeight := LEditControlHeight + 2;
        {$ENDIF}

        LMarginRect.top := (LAvailableHeight - LEditControlHeight) / 2;
        LMarginRect.bottom := (LAvailableHeight - LEditControlHeight) / 2;
      end;
      {$ENDIF}

      if LInlinedLabelText then begin
        Var LAvailableHeight := Height - LStrokeSize.Top - LStrokeSize.bottom - Padding.top - Padding.Bottom;
        var LEditControlHeight := GetLineHeight;
        {$IF defined(ALMacOS)}
        // For an obscure reason, when FocusRingType is set to NSFocusRingTypeNone and the font size
        // is not 16, focusing on the EditField causes it to shift up by 2 pixels.
        LEditControlHeight := LEditControlHeight + 2;
        {$ENDIF}

        LMarginRect.top := (LAvailableHeight - LEditControlHeight - BufLabelTextDrawableRect.Height - LabelTextSettings.Margins.Top - LabelTextSettings.Margins.bottom) / 2;
        LMarginRect.top := LMarginRect.top + BufLabelTextDrawableRect.Height + LabelTextSettings.Margins.Top + LabelTextSettings.Margins.bottom;
        LMarginRect.bottom := (LAvailableHeight - LEditControlHeight - BufLabelTextDrawableRect.Height - LabelTextSettings.Margins.Top - LabelTextSettings.Margins.bottom) / 2;
      end;

      LMarginRect.left :=   Max(LMarginRect.left   + LStrokeSize.left,   0);
      LMarginRect.Top :=    Max(LMarginRect.Top    + LStrokeSize.Top,    0);
      LMarginRect.Right :=  Max(LMarginRect.Right  + LStrokeSize.Right,  0);
      LMarginRect.Bottom := Max(LMarginRect.Bottom + LStrokeSize.Bottom, 0);

      EditControl.Margins.Rect := LMarginRect;

    finally
      TNonReentrantHelper.LeaveSection(FIsAdjustingSize)
    end;
  end;
end;

{*****************}
procedure Register;
begin
  RegisterComponents('Alcinoe', [TALEdit]);
  {$IFDEF ALDPK}
  UnlistPublishedProperty(TALEdit, 'Size');
  UnlistPublishedProperty(TALEdit, 'StyleName');
  UnlistPublishedProperty(TALEdit, 'OnTap');
  {$ENDIF}
end;

initialization
  RegisterFmxClasses([TALEdit]);

end.
