unit Alcinoe.FMX.StdCtrls;

interface

{$I Alcinoe.inc}

{$IFNDEF ALCompilerVersionSupported120}
  {$MESSAGE WARN 'Check if FMX.StdCtrls.pas was not updated and adjust the IFDEF'}
{$ENDIF}

uses
  System.Classes,
  System.Types,
  {$IFDEF DEBUG}
  System.Diagnostics,
  {$ENDIF}
  System.UITypes,
  System.ImageList,
  System.Math,
  System.Rtti,
  System.Messaging,
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
  FMX.types3D,
  {$ENDIF}
  FMX.types,
  FMX.stdActns,
  FMX.Controls,
  FMX.Graphics,
  FMX.StdCtrls,
  FMX.actnlist,
  FMX.ImgList,
  Alcinoe.FMX.BreakText,
  Alcinoe.FMX.Ani,
  Alcinoe.FMX.Graphics,
  Alcinoe.FMX.ScrollEngine,
  Alcinoe.FMX.Controls,
  Alcinoe.FMX.Common,
  Alcinoe.FMX.Objects;

type

  {~~~~~~~~~~~~~~~~~~~~~~~~~}
  [ComponentPlatforms($FFFF)]
  TALAniIndicator = class(TALControl, IALDoubleBufferedControl)
  public const
    DefaultEnabled = False;
  private
    fTimer: TTimer;
    finterval: integer;
    FFrameCount: Integer;
    FRowCount: Integer;
    fResourceName: String;
    fFrameIndex: TSmallPoint;
    fBufDrawable: TALDrawable;
    fBufDrawableRect: TRectF;
    procedure setResourceName(const Value: String);
    procedure onTimer(sender: Tobject);
    function ResourceNameStored: Boolean;
  protected
    function GetDoubleBuffered: boolean;
    procedure SetDoubleBuffered(const AValue: Boolean);
    procedure Paint; override;
    property BufDrawable: TALDrawable read fBufDrawable;
    property BufDrawableRect: TRectF read fBufDrawableRect;
    function EnabledStored: Boolean; override;
    procedure SetEnabled(const Value: Boolean); override;
    function GetDefaultSize: TSizeF; override;
    procedure DoResized; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MakeBufDrawable; virtual;
    procedure clearBufDrawable; virtual;
  published
    //property Action;
    property Align;
    property Anchors;
    //property CanFocus;
    //property CanParentFocus;
    //property DisableFocusEffect;
    //property ClipChildren;
    //property ClipParent;
    property Cursor;
    property DragMode;
    property EnableDragHighlight;
    property Enabled stored EnabledStored default DefaultEnabled;
    property Height;
    //property Hint;
    //property ParentShowHint;
    //property ShowHint;
    property HitTest;
    property Locked;
    property Margins;
    property Opacity;
    property Padding;
    property PopupMenu;
    property Position;
    property ResourceName: String read fResourceName write setResourceName stored ResourceNameStored nodefault;
    property FrameCount: Integer read FFrameCount write FFrameCount default 20;
    property RowCount: Integer read FRowCount write FRowCount default 4;
    property Interval: integer read finterval write finterval default 50;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    //property TabOrder;
    //property TabStop;
    property TouchTargetExpansion;
    property Visible;
    property Width;
    //property OnCanFocus;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    //property OnEnter;
    //property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseWheel;
    property OnClick;
    //property OnDblClick;
    //property OnKeyDown;
    //property OnKeyUp;
    property OnPainting;
    property OnPaint;
    //property OnResize;
    property OnResized;
  end;

  {~~~~~~~~~~~~~~~~~~~~~}
  TALCustomTrack = class;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  (* todo move it inside TALCustomTrack *)
  TALTrackThumbGlyph = class(TALImage)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align default TalignLayout.Client;
    property HitTest default false;
    property Locked default True;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  TALTrackThumb = class(TALBaseRectangle)
  private
    fValueRange: TValueRange;
    FTrack: TALCustomTrack;
    FGlyph: TALTrackThumbGlyph;
    fMouseDownPos: TPointF;
    fTrackMouseDownPos: TPointF;
    FPressed: Boolean;
    fScrollCapturedByMe: boolean;
    procedure ScrollCapturedByOtherHandler(const Sender: TObject; const M: TMessage);
    function PointToValue(X, Y: Single): Double;
  public
    constructor Create(const ATrack: TALCustomTrack; const aValueRange: TValueRange; const aWithGlyphObj: boolean); reintroduce;
    destructor Destroy; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure DoMouseLeave; override;
    function GetDefaultTouchTargetExpansion: TRectF; override;
    property Pressed: Boolean read FPressed;
  published
    property Cursor default crHandPoint;
    property Glyph: TALTrackThumbGlyph read FGlyph;
    property Locked default True;
    property Position stored false;
    property Size stored false;
    property TouchTargetExpansion;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  TALTrackBackground = class(TALBaseRectangle)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property HitTest default false;
    property Locked default True;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  TALTrackHighlight = class(TALBaseRectangle)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property HitTest default false;
    property Locked default True;
    property Position stored false;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  TALCustomTrack = class(TALControl, IValueRange)
  private
    FValueRange: TValueRange;
    FDefaultValueRange: TBaseValueRange;
    function GetIsTracking: Boolean;
    function GetValueRange: TCustomValueRange;
    procedure SetValueRange(const AValue: TCustomValueRange);
    procedure SetValueRange_(const Value: TValueRange);
    function FrequencyStored: Boolean;
    function MaxStored: Boolean;
    function MinStored: Boolean;
    procedure SetThumbSize(const Value: Single);
    function ThumbSizeStored: Boolean;
    function ViewportSizeStored: Boolean;
  protected
    FOnChange: TNotifyEvent;
    FOnTracking: TNotifyEvent;
    FIgnoreViewportSize: Boolean;
    FOrientation: TOrientation;
    FTracking: Boolean;
    FThumbSize: Single;
    FMinThumbSize: Single;
    FThumb: TALTrackThumb;
    FBackGround: TALTrackBackground;
    FHighlight: TALTrackHighlight;
    procedure SetViewportSize(const Value: Double); virtual;
    function GetViewportSize: Double; virtual;
    function GetFrequency: Double; virtual;
    procedure SetFrequency(const Value: Double); virtual;
    function GetMax: Double; virtual;
    procedure SetMax(const Value: Double); virtual;
    function GetMin: Double; virtual;
    procedure SetMin(const Value: Double); virtual;
    function GetValue: Double; virtual;
    procedure SetValue(Value: Double); virtual;
    function ValueStored: Boolean; virtual;
    function GetData: TValue; override;
    procedure SetData(const Value: TValue); override;
    procedure SetOrientation(const Value: TOrientation); virtual;
    function GetThumbRect(const Value: single; const aThumb: TALTrackThumb): TRectF; overload; virtual;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    function GetDefaultTouchTargetExpansion: TRectF; override;
    function GetThumbSize(var IgnoreViewportSize: Boolean): Integer; virtual;
    procedure DoRealign; override;
    procedure Loaded; override;
    procedure DoChanged; virtual;
    procedure DoTracking; virtual;
    function CreateValueRangeTrack : TValueRange; virtual;
    property DefaultValueRange: TBaseValueRange read FDefaultValueRange;
    property ValueRange: TValueRange read FValueRange write SetValueRange_ stored ValueStored;
    property Value: Double read GetValue write SetValue stored ValueStored nodefault;
    property Thumb: TALTrackThumb read FThumb;
    procedure UpdateHighlight; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    property IsTracking: Boolean read GetIsTracking;
    property Min: Double read GetMin write SetMin stored MinStored nodefault;
    property Max: Double read GetMax write SetMax stored MaxStored nodefault;
    property Frequency: Double read GetFrequency write SetFrequency stored FrequencyStored nodefault;
    property ViewportSize: Double read GetViewportSize write SetViewportSize stored ViewportSizeStored nodefault;
    property Orientation: TOrientation read FOrientation write SetOrientation;
    property Tracking: Boolean read FTracking write FTracking default True;
    property ThumbSize: Single read fThumbSize write SetThumbSize Stored ThumbSizeStored nodefault; // 0 mean the thumb will have the height of the track in horizontal or width of the track in vertical
    property BackGround: TALTrackBackground read FBackGround;
    property Highlight: TALTrackHighlight read FHighlight;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnTracking: TNotifyEvent read FOnTracking write FOnTracking;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~}
  [ComponentPlatforms($FFFF)]
  TALTrackBar = class(TALCustomTrack)
  protected
    function GetDefaultSize: TSizeF; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ValueRange;
  published
    //property Action;
    property Align;
    property Anchors;
    property BackGround;
    property CanFocus default True;
    //property CanParentFocus;
    //property DisableFocusEffect;
    property ClipChildren;
    //property ClipParent;
    property Cursor;
    property DragMode;
    property EnableDragHighlight;
    property Enabled;
    property Frequency;
    property Height;
    property Highlight;
    //property Hint;
    //property ParentShowHint;
    //property ShowHint;
    property HitTest;
    property Locked;
    property Margins;
    property Min;
    property Max;
    property Opacity;
    property Orientation;
    property Padding;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property TabOrder;
    property TabStop;
    property Thumb;
    property ThumbSize; (* todo: delete *)
    property TouchTargetExpansion;
    property Tracking;
    property Value;
    property Visible;
    property Width;
    property OnCanFocus;
    property OnChange;
    property OnTracking;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseWheel;
    property OnClick;
    //property OnDblClick;
    property OnKeyDown;
    property OnKeyUp;
    property OnPainting;
    property OnPaint;
    //property OnResize;
    property OnResized;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~}
  [ComponentPlatforms($FFFF)]
  TALScrollBar = class(TALCustomTrack)
  protected
    function GetDefaultSize: TSizeF; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ValueRange;
  published
    //property Action;
    property Align;
    property Anchors;
    property BackGround;
    property CanFocus default False;
    //property CanParentFocus;
    //property DisableFocusEffect;
    property ClipChildren;
    //property ClipParent;
    property Cursor;
    property DragMode;
    property EnableDragHighlight;
    property Enabled;
    property Height;
    //property Hint;
    //property ParentShowHint;
    //property ShowHint;
    property HitTest;
    property Locked;
    property Margins;
    property Min;
    property Max;
    property Opacity;
    property Orientation;
    property Padding;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property TabOrder;
    property TabStop;
    property Thumb;
    property TouchTargetExpansion;
    property Value;
    property ViewportSize;
    property Visible;
    property Width;
    property OnCanFocus;
    property OnChange;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseWheel;
    property OnClick;
    //property OnDblClick;
    property OnKeyDown;
    property OnKeyUp;
    property OnPainting;
    property OnPaint;
    //property OnResize;
    property OnResized;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~}
  [ComponentPlatforms($FFFF)]
  TALRangeTrackBar = class(TALCustomTrack)
  private
    FMaxValueRange: TValueRange;
  protected
    FMaxThumb: TALTrackThumb;
    procedure SetViewportSize(const Value: Double); override;
    procedure SetFrequency(const Value: Double); override;
    procedure SetMax(const Value: Double); override;
    procedure SetMin(const Value: Double); override;
    function MaxValueStored: Boolean; virtual;
    function GetDefaultSize: TSizeF; override;
    procedure SetValue(Value: Double); override;
    function GetMaxValue: Double; virtual;
    procedure SetMaxValue(Value: Double); virtual;
    procedure Loaded; override;
    procedure DoRealign; override;
    procedure UpdateHighlight; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //property Action;
    property Align;
    property Anchors;
    property BackGround;
    property CanFocus default True;
    //property CanParentFocus;
    //property DisableFocusEffect;
    property ClipChildren;
    //property ClipParent;
    property Cursor;
    property DragMode;
    property EnableDragHighlight;
    property Enabled;
    property Frequency;
    property Height;
    property Highlight;
    //property Hint;
    //property ParentShowHint;
    //property ShowHint;
    property HitTest;
    property Locked;
    property Margins;
    property Min;
    property Max;
    property MinValue: Double read GetValue write SetValue stored ValueStored nodefault;
    property MaxValue: Double read GetMaxValue write SetMaxValue stored MaxValueStored nodefault;
    property MinThumb: TALTrackThumb read FThumb;
    property MaxThumb: TALTrackThumb read FMaxThumb;
    property ThumbSize;  (* todo delete *)
    property Opacity;
    property Orientation;
    property Padding;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property TabOrder;
    property TabStop;
    property TouchTargetExpansion;
    property Tracking;
    property Value;
    property Visible;
    property Width;
    property OnCanFocus;
    property OnChange;
    property OnTracking;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseWheel;
    property OnClick;
    //property OnDblClick;
    property OnKeyDown;
    property OnKeyUp;
    property OnPainting;
    property OnPaint;
    //property OnResize;
    property OnResized;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  TALBaseCheckBox = class(TALShape, IALDoubleBufferedControl)
  public
    type
      // ---------------
      // TCheckMarkBrush
      TCheckMarkBrush = class(TALPersistentObserver)
      private
        FColor: TAlphaColor;
        FResourceName: String;
        FWrapMode: TALImageWrapMode;
        FThickness: Single;
        FMargins: TBounds;
        FDefaultColor: TAlphaColor;
        FDefaultResourceName: String;
        FDefaultWrapMode: TALImageWrapMode;
        FDefaultThickness: Single;
        procedure SetColor(const Value: TAlphaColor);
        procedure SetResourceName(const Value: String);
        procedure SetWrapMode(const Value: TALImageWrapMode);
        procedure SetThickness(const Value: Single);
        procedure SetMargins(const Value: TBounds);
        procedure MarginsChanged(Sender: TObject); virtual;
        function IsColorStored: Boolean;
        function IsResourceNameStored: Boolean;
        function IsWrapModeStored: Boolean;
        function IsThicknessStored: Boolean;
      protected
        function CreateSavedState: TALPersistentObserver; override;
      public
        constructor Create(const ADefaultColor: TAlphaColor); reintroduce; virtual;
        destructor Destroy; override;
        procedure Assign(Source: TPersistent); override;
        procedure Reset; override;
        procedure Interpolate(const ATo: TCheckMarkBrush; const ANormalizedTime: Single); virtual;
        procedure InterpolateNoChanges(const ATo: TCheckMarkBrush; const ANormalizedTime: Single);
        function HasCheckMark: boolean;
        property DefaultColor: TAlphaColor read FDefaultColor write FDefaultColor;
        property DefaultResourceName: String read FDefaultResourceName write FDefaultResourceName;
        property DefaultWrapMode: TALImageWrapMode read FDefaultWrapMode write FDefaultWrapMode;
        property DefaultThickness: Single read FDefaultThickness write FDefaultThickness;
      published
        property Color: TAlphaColor read FColor write SetColor stored IsColorStored;
        property ResourceName: String read FResourceName write SetResourceName stored IsResourceNameStored nodefault;
        property WrapMode: TALImageWrapMode read FWrapMode write SetWrapMode stored IsWrapModeStored;
        property Thickness: Single read FThickness write SetThickness stored IsThicknessStored nodefault;
        property Margins: TBounds read FMargins write SetMargins;
      end;
      // ----------------------
      // TInheritCheckMarkBrush
      TInheritCheckMarkBrush = class(TCheckMarkBrush)
      private
        FParent: TCheckMarkBrush;
        FInherit: Boolean;
        fSuperseded: Boolean;
        procedure SetInherit(const AValue: Boolean);
      protected
        function CreateSavedState: TALPersistentObserver; override;
        procedure DoSupersede; virtual;
      public
        constructor Create(const AParent: TCheckMarkBrush; const ADefaultColor: TAlphaColor); reintroduce; virtual;
        procedure Assign(Source: TPersistent); override;
        procedure Reset; override;
        procedure Supersede(Const ASaveState: Boolean = False); virtual;
        procedure SupersedeNoChanges(Const ASaveState: Boolean = False);
        property Superseded: Boolean read FSuperseded;
        property Parent: TCheckMarkBrush read FParent;
      published
        property Inherit: Boolean read FInherit write SetInherit Default True;
      end;
      // ---------------
      // TBaseStateStyle
      TBaseStateStyle = class(TALBaseStateStyle)
      private
        FCheckMark: TInheritCheckMarkBrush;
        function GetStateStyleParent: TBaseStateStyle;
        function GetControlParent: TALBaseCheckBox;
        procedure SetCheckMark(const AValue: TInheritCheckMarkBrush);
        procedure CheckMarkChanged(ASender: TObject);
      protected
        function GetInherit: Boolean; override;
        procedure DoSupersede; override;
      public
        constructor Create(const AParent: TObject); override;
        destructor Destroy; override;
        procedure Assign(Source: TPersistent); override;
        procedure Reset; override;
        procedure Interpolate(const ATo: TALBaseStateStyle; const ANormalizedTime: Single); override;
        property StateStyleParent: TBaseStateStyle read GetStateStyleParent;
        property ControlParent: TALBaseCheckBox read GetControlParent;
      published
        property CheckMark: TInheritCheckMarkBrush read FCheckMark write SetCheckMark;
      end;
      // ------------------
      // TDefaultStateStyle
      TDefaultStateStyle = class(TBaseStateStyle)
      published
        property Fill;
        property Shadow;
        property Stroke;
      end;
      // -------------------
      // TDisabledStateStyle
      TDisabledStateStyle = class(TBaseStateStyle)
      private
        FOpacity: Single;
        procedure SetOpacity(const Value: Single);
        function IsOpacityStored: Boolean;
      protected
        function GetInherit: Boolean; override;
      public
        constructor Create(const AParent: TObject); override;
        procedure Assign(Source: TPersistent); override;
        procedure Reset; override;
      published
        property Fill;
        property Opacity: Single read FOpacity write SetOpacity stored IsOpacityStored nodefault;
        property Shadow;
        property Stroke;
      end;
      // ------------------
      // THoveredStateStyle
      THoveredStateStyle = class(TBaseStateStyle)
      published
        property Fill;
        property Shadow;
        property StateLayer;
        property Stroke;
      end;
      // ------------------
      // TPressedStateStyle
      TPressedStateStyle = class(TBaseStateStyle)
      published
        property Fill;
        property Shadow;
        property StateLayer;
        property Stroke;
      end;
      // ------------------
      // TFocusedStateStyle
      TFocusedStateStyle = class(TBaseStateStyle)
      published
        property Fill;
        property Shadow;
        property StateLayer;
        property Stroke;
      end;
      // -----------------
      // TCheckStateStyles
      TCheckStateStyles = class(TALPersistentObserver)
      private
        FDefault: TDefaultStateStyle;
        FDisabled: TDisabledStateStyle;
        FHovered: THoveredStateStyle;
        FPressed: TPressedStateStyle;
        FFocused: TFocusedStateStyle;
        procedure SetDefault(const AValue: TDefaultStateStyle);
        procedure SetDisabled(const AValue: TDisabledStateStyle);
        procedure SetHovered(const AValue: THoveredStateStyle);
        procedure SetPressed(const AValue: TPressedStateStyle);
        procedure SetFocused(const AValue: TFocusedStateStyle);
        procedure DefaultChanged(ASender: TObject);
        procedure DisabledChanged(ASender: TObject);
        procedure HoveredChanged(ASender: TObject);
        procedure PressedChanged(ASender: TObject);
        procedure FocusedChanged(ASender: TObject);
      protected
        function CreateSavedState: TALPersistentObserver; override;
      public
        constructor Create(const AParent: TALBaseCheckBox); reintroduce; virtual;
        destructor Destroy; override;
        procedure Assign(Source: TPersistent); override;
        procedure Reset; override;
        procedure ClearBufDrawable; virtual;
      published
        property &Default: TDefaultStateStyle read FDefault write SetDefault;
        property Disabled: TDisabledStateStyle read FDisabled write SetDisabled;
        property Hovered: THoveredStateStyle read FHovered write SetHovered;
        property Pressed: TPressedStateStyle read FPressed write SetPressed;
        property Focused: TFocusedStateStyle read FFocused write SetFocused;
      end;
      // ------------
      // TStateStyles
      TStateStyles = class(TALBaseStateStyles)
      private
        FChecked: TCheckStateStyles;
        FUnchecked: TCheckStateStyles;
        function GetParent: TALBaseCheckBox;
        procedure SetChecked(const AValue: TCheckStateStyles);
        procedure SetUnchecked(const AValue: TCheckStateStyles);
        procedure CheckedChanged(ASender: TObject);
        procedure UncheckedChanged(ASender: TObject);
      protected
        function CreateSavedState: TALPersistentObserver; override;
      public
        constructor Create(const AParent: TALBaseCheckBox); reintroduce; virtual;
        destructor Destroy; override;
        procedure Assign(Source: TPersistent); override;
        procedure Reset; override;
        procedure ClearBufDrawable; override;
        function GetCurrentRawStyle: TALBaseStateStyle; override;
        Property Parent: TALBaseCheckBox read GetParent;
      published
        property Checked: TCheckStateStyles read FChecked write SetChecked;
        property Unchecked: TCheckStateStyles read FUnchecked write SetUnchecked;
      end;
  private
    FStateStyles: TStateStyles;
    FCheckMark: TCheckMarkBrush;
    FChecked: Boolean;
    FDoubleBuffered: boolean;
    FXRadius: Single;
    FYRadius: Single;
    FOnChange: TNotifyEvent;
    FDefaultXRadius: Single;
    FDefaultYRadius: Single;
    procedure SetCheckMark(const Value: TCheckMarkBrush);
    procedure SetStateStyles(const AValue: TStateStyles);
    function IsXRadiusStored: Boolean;
    function IsYRadiusStored: Boolean;
  protected
    function CreateStateStyles: TStateStyles; virtual;
    function GetDoubleBuffered: boolean; virtual;
    procedure SetDoubleBuffered(const AValue: Boolean); virtual;
    procedure SetXRadius(const Value: Single); virtual;
    procedure SetYRadius(const Value: Single); virtual;
    procedure CheckMarkChanged(Sender: TObject); virtual;
    procedure StateStylesChanged(Sender: TObject); virtual;
    procedure FillChanged(Sender: TObject); override;
    procedure StrokeChanged(Sender: TObject); override;
    procedure ShadowChanged(Sender: TObject); override;
    procedure IsMouseOverChanged; override;
    procedure IsFocusedChanged; override;
    procedure PressedChanged; override;
    function GetDefaultSize: TSizeF; override;
    function GetChecked: Boolean; virtual;
    procedure SetChecked(const Value: Boolean); virtual;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    procedure Click; override;
    procedure DoChanged; virtual;
    procedure DoResized; override;
    procedure DrawCheckMark(
                const ACanvas: TALCanvas;
                const AScale: Single;
                const ADstRect: TrectF;
                const AChecked: Boolean;
                const ACheckMark: TCheckMarkBrush); virtual;
    Procedure CreateBufDrawable(
                var ABufDrawable: TALDrawable;
                out ABufDrawableRect: TRectF;
                const AFill: TALBrush;
                const AStateLayer: TALStateLayer;
                const AStroke: TALStrokeBrush;
                const ACheckMark: TCheckMarkBrush;
                const AShadow: TALShadow); virtual;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MakeBufDrawable; virtual;
    procedure clearBufDrawable; virtual;
    property CanFocus default True;
    property Cursor default crHandPoint;
    property Checked: Boolean read GetChecked write SetChecked default False;
    property CheckMark: TCheckMarkBrush read FCheckMark write SetCheckMark;
    property DoubleBuffered: Boolean read GetDoubleBuffered write SetDoubleBuffered default true;
    property StateStyles: TStateStyles read FStateStyles write SetStateStyles;
    property XRadius: Single read FXRadius write SetXRadius stored IsXRadiusStored nodefault;
    property YRadius: Single read FYRadius write SetYRadius stored IsYRadiusStored nodefault;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property DefaultXRadius: Single read FDefaultXRadius write FDefaultXRadius;
    property DefaultYRadius: Single read FDefaultYRadius write FDefaultYRadius;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~}
  [ComponentPlatforms($FFFF)]
  TALCheckBox = class(TALBaseCheckBox)
  public
    type
      // ------------
      // TStateStyles
      TCheckBoxStateStyles = class(TALBaseCheckBox.TStateStyles)
      published
        property Transition;
      end;
  private
    function GetStateStyles: TCheckBoxStateStyles;
    procedure SetStateStyles(const AValue: TCheckBoxStateStyles);
  protected
    function CreateStateStyles: TALBaseCheckBox.TStateStyles; override;
  published
    //property Action;
    property Align;
    property Anchors;
    property CanFocus;
    //property CanParentFocus;
    //property DisableFocusEffect;
    property CheckMark;
    property Checked;
    property ClipChildren;
    //property ClipParent;
    property Cursor;
    property DoubleBuffered;
    property DragMode;
    property EnableDragHighlight;
    property Enabled;
    property Fill;
    property Height;
    //property Hint;
    //property ParentShowHint;
    //property ShowHint;
    property HitTest;
    property Locked;
    property Margins;
    property Opacity;
    property Padding;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Shadow;
    property Size;
    property StateStyles: TCheckBoxStateStyles read GetStateStyles write SetStateStyles;
    property Stroke;
    property TabOrder;
    property TabStop;
    property TouchTargetExpansion;
    property Visible;
    property Width;
    property XRadius;
    property YRadius;
    property OnCanFocus;
    property OnChange;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseWheel;
    property OnClick;
    //property OnDblClick;
    property OnKeyDown;
    property OnKeyUp;
    property OnPainting;
    property OnPaint;
    //property OnResize;
    property OnResized;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~}
  [ComponentPlatforms($FFFF)]
  TALRadioButton = class(TALCheckBox)
  private
    FGroupName: string;
    fMandatory: boolean;
    function GetGroupName: string;
    procedure SetGroupName(const Value: string);
    function GroupNameStored: Boolean;
    procedure GroupMessageCall(const Sender : TObject; const M : TMessage);
  protected
    procedure SetChecked(const Value: Boolean); override;
    function GetDefaultSize: TSizeF; override;
    procedure DrawCheckMark(
                const ACanvas: TALCanvas;
                const AScale: Single;
                const ADstRect: TrectF;
                const AChecked: Boolean;
                const ACheckMark: TALBaseCheckBox.TCheckMarkBrush); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property GroupName: string read GetGroupName write SetGroupName stored GroupNameStored nodefault;
    property Mandatory: Boolean read fMandatory write fMandatory default false;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~}
  [ComponentPlatforms($FFFF)]
  TALSwitch = class(TALControl, IALDoubleBufferedControl)
  public
    type
      // ------
      // TTrack
      TTrack = class(TALShape, IALDoubleBufferedControl)
      public
        type
          // ---------------
          // TBaseStateStyle
          TBaseStateStyle = class(TALBaseStateStyle)
          public
            constructor Create(const AParent: TObject); override;
          end;
          // ------------------
          // TDefaultStateStyle
          TDefaultStateStyle = class(TBaseStateStyle)
          published
            property Fill;
            property Shadow;
            property Stroke;
          end;
          // -------------------
          // TDisabledStateStyle
          TDisabledStateStyle = class(TBaseStateStyle)
          private
            FOpacity: Single;
            procedure SetOpacity(const Value: Single);
            function IsOpacityStored: Boolean;
          protected
            function GetInherit: Boolean; override;
          public
            constructor Create(const AParent: TObject); override;
            procedure Assign(Source: TPersistent); override;
            procedure Reset; override;
          published
            property Fill;
            property Opacity: Single read FOpacity write SetOpacity stored IsOpacityStored nodefault;
            property Shadow;
            property Stroke;
          end;
          // ------------------
          // THoveredStateStyle
          THoveredStateStyle = class(TBaseStateStyle)
          published
            property Fill;
            property Shadow;
            property StateLayer;
            property Stroke;
          end;
          // ------------------
          // TPressedStateStyle
          TPressedStateStyle = class(TBaseStateStyle)
          published
            property Fill;
            property Shadow;
            property StateLayer;
            property Stroke;
          end;
          // ------------------
          // TFocusedStateStyle
          TFocusedStateStyle = class(TBaseStateStyle)
          published
            property Fill;
            property Shadow;
            property StateLayer;
            property Stroke;
          end;
          // -----------------
          // TCheckStateStyles
          TCheckStateStyles = class(TALPersistentObserver)
          private
            FDefault: TDefaultStateStyle;
            FDisabled: TDisabledStateStyle;
            FHovered: THoveredStateStyle;
            FPressed: TPressedStateStyle;
            FFocused: TFocusedStateStyle;
            procedure SetDefault(const AValue: TDefaultStateStyle);
            procedure SetDisabled(const AValue: TDisabledStateStyle);
            procedure SetHovered(const AValue: THoveredStateStyle);
            procedure SetPressed(const AValue: TPressedStateStyle);
            procedure SetFocused(const AValue: TFocusedStateStyle);
            procedure DefaultChanged(ASender: TObject);
            procedure DisabledChanged(ASender: TObject);
            procedure HoveredChanged(ASender: TObject);
            procedure PressedChanged(ASender: TObject);
            procedure FocusedChanged(ASender: TObject);
          protected
            function CreateSavedState: TALPersistentObserver; override;
          public
            constructor Create(const AParent: TTrack); reintroduce; virtual;
            destructor Destroy; override;
            procedure Assign(Source: TPersistent); override;
            procedure Reset; override;
            procedure ClearBufDrawable; virtual;
          published
            property &Default: TDefaultStateStyle read FDefault write SetDefault;
            property Disabled: TDisabledStateStyle read FDisabled write SetDisabled;
            property Hovered: THoveredStateStyle read FHovered write SetHovered;
            property Pressed: TPressedStateStyle read FPressed write SetPressed;
            property Focused: TFocusedStateStyle read FFocused write SetFocused;
          end;
          // ------------
          // TStateStyles
          TStateStyles = class(TALBaseStateStyles)
          private
            FChecked: TCheckStateStyles;
            FUnchecked: TCheckStateStyles;
            function GetParent: TTrack;
            procedure SetChecked(const AValue: TCheckStateStyles);
            procedure SetUnchecked(const AValue: TCheckStateStyles);
            procedure CheckedChanged(ASender: TObject);
            procedure UncheckedChanged(ASender: TObject);
          protected
            function CreateSavedState: TALPersistentObserver; override;
          public
            constructor Create(const AParent: TTrack); reintroduce; virtual;
            destructor Destroy; override;
            procedure Assign(Source: TPersistent); override;
            procedure Reset; override;
            procedure ClearBufDrawable; override;
            function GetCurrentRawStyle: TALBaseStateStyle; override;
            Property Parent: TTrack read GetParent;
          published
            property Checked: TCheckStateStyles read FChecked write SetChecked;
            property Unchecked: TCheckStateStyles read FUnchecked write SetUnchecked;
          end;
      private
        FStateStyles: TStateStyles;
        FChecked: Boolean;
        FDoubleBuffered: boolean;
        FXRadius: Single;
        FYRadius: Single;
        FDefaultXRadius: Single;
        FDefaultYRadius: Single;
        procedure SetStateStyles(const AValue: TStateStyles);
        function IsXRadiusStored: Boolean;
        function IsYRadiusStored: Boolean;
      protected
        function GetDefaultSize: TSizeF; override;
        function GetDoubleBuffered: boolean;
        procedure SetDoubleBuffered(const AValue: Boolean);
        procedure SetXRadius(const Value: Single); virtual;
        procedure SetYRadius(const Value: Single); virtual;
        procedure StateStylesChanged(Sender: TObject); virtual;
        procedure FillChanged(Sender: TObject); override;
        procedure StrokeChanged(Sender: TObject); override;
        procedure ShadowChanged(Sender: TObject); override;
        procedure IsMouseOverChanged; override;
        procedure IsFocusedChanged; override;
        procedure PressedChanged; override;
        function GetChecked: Boolean; virtual;
        procedure SetChecked(const Value: Boolean); virtual;
        procedure DoChanged; virtual;
        procedure DoResized; override;
        Procedure CreateBufDrawable(
                    var ABufDrawable: TALDrawable;
                    out ABufDrawableRect: TRectF;
                    const AFill: TALBrush;
                    const AStateLayer: TALStateLayer;
                    const AStroke: TALStrokeBrush;
                    const AShadow: TALShadow); virtual;
        procedure Paint; override;
        property Checked: Boolean read GetChecked write SetChecked default False;
        property DoubleBuffered: Boolean read GetDoubleBuffered write SetDoubleBuffered default true;
      public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure MakeBufDrawable; virtual;
        procedure clearBufDrawable; virtual;
        property DefaultXRadius: Single read FDefaultXRadius write FDefaultXRadius;
        property DefaultYRadius: Single read FDefaultYRadius write FDefaultYRadius;
      published
        //property Action;
        //property Align;
        //property Anchors;
        //property CanFocus default False;
        //property CanParentFocus;
        //property DisableFocusEffect;
        //property ClipChildren;
        //property ClipParent;
        //property Cursor;
        //property DragMode;
        //property EnableDragHighlight;
        //property Enabled;
        property Fill;
        //property Height;
        //property Hint;
        //property ParentShowHint;
        //property ShowHint;
        //property HitTest default False;
        //property Locked default True;
        property Margins;
        property Opacity;
        property Padding;
        //property PopupMenu;
        //property Position;
        //property RotationAngle;
        //property RotationCenter;
        //property Scale;
        property Shadow;
        //property Size;
        property StateStyles: TStateStyles read FStateStyles write SetStateStyles;
        property Stroke;
        //property TabOrder;
        //property TabStop;
        //property TouchTargetExpansion;
        //property Visible;
        //property Width;
        property XRadius: Single read FXRadius write SetXRadius stored IsXRadiusStored nodefault;
        property YRadius: Single read FYRadius write SetYRadius stored IsYRadiusStored nodefault;
        //property OnCanFocus;
        //property OnDragEnter;
        //property OnDragLeave;
        //property OnDragOver;
        //property OnDragDrop;
        //property OnDragEnd;
        //property OnEnter;
        //property OnExit;
        //property OnMouseEnter;
        //property OnMouseLeave;
        //property OnMouseDown;
        //property OnMouseUp;
        //property OnMouseMove;
        //property OnMouseWheel;
        //property OnClick;
        //property OnDblClick;
        //property OnKeyDown;
        //property OnKeyUp;
        property OnPainting;
        property OnPaint;
        //property OnResize;
        //property OnResized;
      end;
      // ------
      // TThumb
      TThumb = class(TALBaseCheckBox)
      public
        type
          // ------------
          // TStateStyles
          TThumbStateStyles = class(TALBaseCheckBox.TStateStyles)
          private
            FStartPositionX: Single;
          protected
            procedure StartTransition; override;
            procedure TransitionAnimationProcess(Sender: TObject); override;
            procedure TransitionAnimationFinish(Sender: TObject); override;
          end;
      protected
        function GetDefaultSize: TSizeF; override;
        function CreateStateStyles: TALBaseCheckBox.TStateStyles; override;
        procedure Click; override;
      public
        constructor Create(AOwner: TComponent); override;
      published
        //property Action;
        //property Align;
        //property Anchors;
        //property CanFocus default False;
        //property CanParentFocus;
        //property DisableFocusEffect;
        property CheckMark;
        //property Checked;
        //property ClipChildren;
        //property ClipParent;
        //property Cursor;
        //property DoubleBuffered;
        //property DragMode;
        //property EnableDragHighlight;
        //property Enabled;
        property Fill;
        //property Height;
        //property Hint;
        //property ParentShowHint;
        //property ShowHint;
        //property HitTest default False;
        //property Locked default True;
        property Margins;
        property Opacity;
        property Padding;
        //property PopupMenu;
        //property Position;
        //property RotationAngle;
        //property RotationCenter;
        //property Scale;
        property Shadow;
        property Size;
        property StateStyles;
        property Stroke;
        //property TabOrder;
        //property TabStop;
        //property TouchTargetExpansion;
        //property Visible;
        property Width;
        property XRadius;
        property YRadius;
        //property OnCanFocus;
        //property OnChange;
        //property OnDragEnter;
        //property OnDragLeave;
        //property OnDragOver;
        //property OnDragDrop;
        //property OnDragEnd;
        //property OnEnter;
        //property OnExit;
        //property OnMouseEnter;
        //property OnMouseLeave;
        //property OnMouseDown;
        //property OnMouseUp;
        //property OnMouseMove;
        //property OnMouseWheel;
        //property OnClick;
        //property OnDblClick;
        //property OnKeyDown;
        //property OnKeyUp;
        property OnPainting;
        property OnPaint;
        //property OnResize;
        //property OnResized;
      end;
  private
    FThumb: TThumb;
    FTrack: TTrack;
    FTransition: TALStateTransition;
    FPressedThumbPos: TPointF;
    FOnChange: TNotifyEvent;
    fScrollCapturedByMe: boolean;
    procedure ScrollCapturedByOtherHandler(const Sender: TObject; const M: TMessage);
    procedure SetTransition(const Value: TALStateTransition);
    procedure TransitionChanged(ASender: TObject);
    function GetMinThumbPos: Single;
    function GetMaxThumbPos: Single;
    procedure AlignThumb;
  protected
    function GetDefaultSize: TSizeF; override;
    function GetDoubleBuffered: boolean;
    procedure SetDoubleBuffered(const AValue: Boolean);
    procedure StartTransition; virtual;
    procedure IsMouseOverChanged; override;
    procedure IsFocusedChanged; override;
    procedure PressedChanged; override;
    procedure EnabledChanged; override;
    procedure DoChange;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure DoMouseLeave; override;
    procedure Click; override;
    function GetChecked: boolean; virtual;
    procedure SetChecked(const Value: Boolean); virtual;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MakeBufDrawable; virtual;
    procedure clearBufDrawable; virtual;
  published
    //property Action;
    property Align;
    property Anchors;
    property CanFocus default true;
    //property CanParentFocus;
    //property DisableFocusEffect;
    property DoubleBuffered: Boolean read GetDoubleBuffered write SetDoubleBuffered default true;
    property Checked: Boolean read GetChecked write SetChecked default false;
    property ClipChildren;
    //property ClipParent;
    property Cursor default crHandPoint;
    property DragMode;
    property EnableDragHighlight;
    property Enabled;
    property Height;
    //property Hint;
    //property ParentShowHint;
    //property ShowHint;
    property HitTest;
    property Locked;
    property Margins;
    property Opacity;
    property Padding;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property TabOrder;
    property TabStop;
    property Thumb: TThumb read FThumb;
    property TouchTargetExpansion;
    property Track: TTrack read FTrack;
    property Transition: TALStateTransition read FTransition write SetTransition;
    property Visible;
    property Width;
    property OnCanFocus;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseWheel;
    property OnClick;
    //property OnDblClick;
    property OnKeyDown;
    property OnKeyUp;
    property OnPainting;
    property OnPaint;
    //property OnResize;
    property OnResized;
  end;

  {~~~~~~~~~~~~~~~~~~~~~~~~~}
  [ComponentPlatforms($FFFF)]
  TALButton = class(TALBaseText)
  public
    type
      // -----------------------
      // TStateStyleTextSettings
      TStateStyleTextSettings = class(TALInheritBaseTextSettings)
      published
        property Font;
        property Decoration;
      end;
      // ---------------
      // TBaseStateStyle
      TBaseStateStyle = class(TALBaseStateStyle)
      private
        FText: String;
        FTextSettings: TStateStyleTextSettings;
        FDefaultText: String;
        FPriorSupersedeText: String;
        function GetStateStyleParent: TBaseStateStyle;
        function GetControlParent: TALButton;
        procedure SetText(const Value: string);
        procedure SetTextSettings(const AValue: TStateStyleTextSettings);
        procedure TextSettingsChanged(ASender: TObject);
        function IsTextStored: Boolean;
      protected
        function GetInherit: Boolean; override;
        procedure DoSupersede; override;
      public
        constructor Create(const AParent: TObject); override;
        destructor Destroy; override;
        procedure Assign(Source: TPersistent); override;
        procedure Reset; override;
        procedure Interpolate(const ATo: TALBaseStateStyle; const ANormalizedTime: Single); override;
        property StateStyleParent: TBaseStateStyle read GetStateStyleParent;
        property ControlParent: TALButton read GetControlParent;
        property DefaultText: String read FDefaultText write FDefaultText;
      published
        property Text: string read FText write SetText stored IsTextStored nodefault;
        property TextSettings: TStateStyleTextSettings read fTextSettings write SetTextSettings;
      end;
      // -------------------
      // TDisabledStateStyle
      TDisabledStateStyle = class(TBaseStateStyle)
      private
        FOpacity: Single;
        procedure SetOpacity(const Value: Single);
        function IsOpacityStored: Boolean;
      protected
        function GetInherit: Boolean; override;
      public
        constructor Create(const AParent: TObject); override;
        procedure Assign(Source: TPersistent); override;
        procedure Reset; override;
      published
        property Fill;
        property Scale;
        property Opacity: Single read FOpacity write SetOpacity stored IsOpacityStored nodefault;
        property Shadow;
        property Stroke;
      end;
      // ------------------
      // THoveredStateStyle
      THoveredStateStyle = class(TBaseStateStyle)
      published
        property Fill;
        property Scale;
        property Shadow;
        property StateLayer;
        property Stroke;
      end;
      // ------------------
      // TPressedStateStyle
      TPressedStateStyle = class(TBaseStateStyle)
      published
        property Fill;
        property Scale;
        property Shadow;
        property StateLayer;
        property Stroke;
      end;
      // ------------------
      // TFocusedStateStyle
      TFocusedStateStyle = class(TBaseStateStyle)
      published
        property Fill;
        property Scale;
        property Shadow;
        property StateLayer;
        property Stroke;
      end;
      // ------------
      // TStateStyles
      TStateStyles = class(TALBaseStateStyles)
      private
        FDisabled: TDisabledStateStyle;
        FHovered: THoveredStateStyle;
        FPressed: TPressedStateStyle;
        FFocused: TFocusedStateStyle;
        function GetParent: TALButton;
        procedure SetDisabled(const AValue: TDisabledStateStyle);
        procedure SetHovered(const AValue: THoveredStateStyle);
        procedure SetPressed(const AValue: TPressedStateStyle);
        procedure SetFocused(const AValue: TFocusedStateStyle);
        procedure DisabledChanged(ASender: TObject);
        procedure HoveredChanged(ASender: TObject);
        procedure PressedChanged(ASender: TObject);
        procedure FocusedChanged(ASender: TObject);
      protected
        function CreateSavedState: TALPersistentObserver; override;
      public
        constructor Create(const AParent: TALButton); reintroduce; virtual;
        destructor Destroy; override;
        procedure Assign(Source: TPersistent); override;
        procedure Reset; override;
        procedure ClearBufDrawable; override;
        function GetCurrentRawStyle: TALBaseStateStyle; override;
        Property Parent: TALButton read GetParent;
      published
        property Disabled: TDisabledStateStyle read FDisabled write SetDisabled;
        property Hovered: THoveredStateStyle read FHovered write SetHovered;
        property Pressed: TPressedStateStyle read FPressed write SetPressed;
        property Focused: TFocusedStateStyle read FFocused write SetFocused;
        property Transition;
      end;
      // -------------
      // TTextSettings
      TTextSettings = class(TALBaseTextSettings)
      published
        property Font;
        property Decoration;
        property Trimming;
        property MaxLines;
        property Ellipsis;
        property HorzAlign;
        property VertAlign;
        property LineHeightMultiplier;
        property LetterSpacing;
        property IsHtml;
      end;
  private
    {$IF defined(ALDPK)}
    FPrevStateStyles: TStateStyles;
    {$ENDIF}
    FStateStyles: TStateStyles;
    function GetTextSettings: TTextSettings;
    procedure SetStateStyles(const AValue: TStateStyles);
  protected
    function CreateTextSettings: TALBaseTextSettings; override;
    procedure SetTextSettings(const Value: TTextSettings); reintroduce;
    procedure SetName(const Value: TComponentName); override;
    procedure TextSettingsChanged(Sender: TObject); override;
    procedure SetXRadius(const Value: Single); override;
    procedure SetYRadius(const Value: Single); override;
    procedure StateStylesChanged(Sender: TObject); virtual;
    procedure IsMouseOverChanged; override;
    procedure IsFocusedChanged; override;
    procedure PressedChanged; override;
    procedure Click; override;
    Procedure DrawMultilineTextAdjustRect(const ACanvas: TALCanvas; const AOptions: TALMultiLineTextOptions; var ARect: TrectF; var ASurfaceSize: TSizeF); override;
    procedure Paint; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MakeBufDrawable; override;
    procedure clearBufDrawable; override;
  published
    property AutoSize default True;
    property CanFocus default true;
    property Cursor default crHandPoint;
    property DoubleBuffered;
    property HitTest default True;
    property StateStyles: TStateStyles read FStateStyles write SetStateStyles;
    property TabOrder;
    property TabStop;
    property TextSettings: TTextSettings read GetTextSettings write SetTextSettings;
  end;

procedure Register;

implementation

uses
  System.SysUtils,
  system.Math.Vectors,
  {$IF defined(ALSkiaEngine)}
  System.Skia.API,
  FMX.Skia.Canvas,
  {$ENDIF}
  {$IFDEF ALDPK}
  DesignIntf,
  {$ENDIF}
  {$IF DEFINED(ANDROID)}
  Androidapi.JNI.GraphicsContentViewText,
  {$ENDIF}
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
  FMX.Canvas.GPU,
  Alcinoe.FMX.Types3D,
  {$ENDIF}
  {$IF DEFINED(ALAppleOS)}
  iOSapi.CoreGraphics,
  {$ENDIF}
  FMX.Platform,
  fmx.consts,
  fmx.utils,
  Alcinoe.StringUtils,
  Alcinoe.Common;

{*****************************************************}
constructor TALAniIndicator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  finterval := 50;
  FFrameCount := 20;
  FRowCount := 4;
  fResourceName := 'aniindicator_540x432';
  fFrameIndex := TSmallPoint.Create(0,0);
  fTimer := TTimer.Create(self);
  fTimer.Enabled := False;
  fTimer.Interval := finterval;
  fTimer.OnTimer := onTimer;
  fBufDrawable := ALNullDrawable;
  Enabled := DefaultEnabled;
  SetAcceptsControls(False);
end;

{*********************************}
destructor TALAniIndicator.Destroy;
begin
  fTimer.Enabled := False;
  ALFreeAndNil(fTimer);
  clearBufDrawable;
  inherited;
end;

{**********************************************}
function TALAniIndicator.EnabledStored: Boolean;
begin
  result := Enabled;
end;

{**********************************************}
function TALAniIndicator.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(36, 36);
end;

{**********************************}
procedure TALAniIndicator.DoResized;
begin
  ClearBufDrawable;
  inherited;
end;

{***************************************}
procedure TALAniIndicator.clearBufDrawable;
begin
  {$IFDEF debug}
  if (not (csDestroying in ComponentState)) and
     (not ALIsDrawableNull(fBufDrawable)) then
    ALLog(Classname + '.clearBufDrawable', 'BufDrawable has been cleared | Name: ' + Name, TalLogType.warn);
  {$endif}
  ALFreeAndNilDrawable(fBufDrawable);
end;

{****************************************}
procedure TALAniIndicator.MakeBufDrawable;
begin

  if //--- Do not create BufDrawable if the size is 0
     (Size.Size.IsZero) or
     //--- Do not create BufDrawable if fResourceName is empty
     (fResourceName = '')
  then begin
    clearBufDrawable;
    exit;
  end;

  if (not ALIsDrawableNull(fBufDrawable)) then exit;

  fBufDrawableRect := LocalRect;
  {$IFDEF ALDPK}
  try
    var LFileName := ALGetResourceFilename(FResourceName);
    if LFileName <> '' then fBufDrawable := ALLoadFromFileAndFitIntoToDrawable(LFileName, Width * (fframeCount div fRowCount) * ALGetScreenScale, Height * fRowCount * ALGetScreenScale)
    else fBufDrawable := ALNullDrawable;
  except
    fBufDrawable := ALNullDrawable;
  end;
  {$ELSE}
  fBufDrawable := ALLoadFromResourceAndFitIntoToDrawable(fResourceName, Width * (fframeCount div fRowCount) * ALGetScreenScale, Height * fRowCount * ALGetScreenScale);
  {$ENDIF}

end;

{*************************************************}
procedure TALAniIndicator.onTimer(sender: Tobject);
begin
  inc(fFrameIndex.x);
  if fFrameIndex.x >= FFrameCount div FRowCount then begin
    fFrameIndex.x := 0;
    inc(fFrameIndex.Y);
    if fFrameIndex.Y >= FRowCount then fFrameIndex.Y := 0;
  end;
  repaint;
end;

{******************************}
procedure TALAniIndicator.Paint;
begin

  if (csDesigning in ComponentState) and not Locked and not FInPaintTo then
  begin
    var R := LocalRect;
    InflateRect(R, -0.5, -0.5);
    Canvas.DrawDashRect(R, 0, 0, AllCorners, AbsoluteOpacity, $A0909090);
  end;

  MakeBufDrawable;

  ALDrawDrawable(
    Canvas, // const ACanvas: Tcanvas;
    fBufDrawable, // const ADrawable: TALDrawable;
    TRectF.Create(
      TPointF.Create(
        fFrameIndex.x * Width * ALGetScreenScale,
        fFrameIndex.Y * Height * ALGetScreenScale),
      Width * ALGetScreenScale,
      Height * ALGetScreenScale), // const ASrcRect: TrectF; // IN REAL PIXEL !
    fBufDrawableRect, // const ADestRect: TrectF; // IN virtual pixels !
    AbsoluteOpacity); // const AOpacity: Single);

end;

{***********************************************}
function TALAniIndicator.GetDoubleBuffered: boolean;
begin
  result := True;
end;

{**************************************************************}
procedure TALAniIndicator.SetDoubleBuffered(const AValue: Boolean);
begin
  // Not yet supported
end;

{***************************************************}
function TALAniIndicator.ResourceNameStored: Boolean;
begin
  result := fResourceName <> 'aniindicator_540x432';
end;

{*********************************************************}
procedure TALAniIndicator.SetEnabled(const Value: Boolean);
begin
  if Enabled <> Value then begin
    inherited;
    fTimer.Enabled := Enabled;
  end;
end;

{*************************************************************}
procedure TALAniIndicator.setResourceName(const Value: String);
begin
  if FResourceName <> Value then begin
    clearBufDrawable;
    FResourceName := Value;
    Repaint;
  end;
end;

{***************************************************************************************************************************************}
function _ValueToPos(MinValue, MaxValue, ViewportSize: Double; ThumbSize, TrackSize, Value: Single; IgnoreViewportSize: Boolean): Single;
var ValRel: Double;
begin
  Result := ThumbSize / 2;
  if (ViewportSize < 0) or IgnoreViewportSize then ViewportSize := 0;
  ValRel := MaxValue - MinValue - ViewportSize;
  if ValRel > 0 then begin
    ValRel := (Value - MinValue) / ValRel;
    Result := (TrackSize - ThumbSize) * ValRel + Result;
  end;
end;

{*************************************************************************************************************************************}
function _PosToValue(MinValue, MaxValue, ViewportSize: Double; ThumbSize, TrackSize, Pos: Single; IgnoreViewportSize: Boolean): Double;
var ValRel: Double;
begin
  Result := MinValue;
  if (ViewportSize < 0) or IgnoreViewportSize then ViewportSize := 0;
  ValRel := TrackSize - ThumbSize;
  if ValRel > 0 then begin
    ValRel := (Pos - ThumbSize / 2) / ValRel;
    if ValRel < 0 then ValRel := 0;
    if ValRel > 1 then ValRel := 1;
    Result := MinValue + ValRel * (MaxValue - MinValue - ViewportSize);
  end;
end;

{********************************************************}
constructor TALTrackThumbGlyph.Create(AOwner: TComponent);
begin
  inherited;
  Align := TalignLayout.Client;
  locked := True;
  HitTest := False;
end;

{***************************************************************************************************************************}
constructor TALTrackThumb.Create(const ATrack: TALCustomTrack; const aValueRange: TValueRange; const aWithGlyphObj: boolean);
begin
  inherited create(ATrack);
  cursor := crHandPoint;
  FPressed := False;
  FTrack := ATrack;
  FValueRange := aValueRange;
  CanFocus := False;
  CanParentFocus := True;
  AutoCapture := True;
  Locked := True;
  if aWithGlyphObj then begin
    fGlyph := TALTrackThumbGlyph.Create(self);
    fGlyph.Parent := self;
    fGlyph.Stored := False;
    fGlyph.SetSubComponent(True);
    fGlyph.Name := 'Glyph';
  end
  else fGlyph := nil;
  fMouseDownPos := TpointF.Zero;
  fTrackMouseDownPos := TpointF.Zero;
  fScrollCapturedByMe := False;
  TMessageManager.DefaultManager.SubscribeToMessage(TALScrollCapturedMessage, ScrollCapturedByOtherHandler);
end;

{*******************************}
destructor TALTrackThumb.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TALScrollCapturedMessage, ScrollCapturedByOtherHandler);
  inherited;
end;

{********************************************************}
function TALTrackThumb.PointToValue(X, Y: Single): Double;
var P: TPointF;
begin
  Result := 0;
  if (Parent is TControl) then begin
    if FTrack.Orientation = TOrientation.Horizontal then begin
      P := FTrack.AbsoluteToLocal(LocalToAbsolute(TPointF.Create(X, 0)));
      P.X := P.X - fMouseDownPos.X + Width / 2;
      Result := _PosToValue(FTrack.Min, FTrack.Max, FTrack.ViewportSize, Self.Width, FTrack.Width, P.X, FTrack.FIgnoreViewportSize);
    end
    else begin
      P := FTrack.AbsoluteToLocal(LocalToAbsolute(TPointF.Create(0, Y)));
      P.Y := P.Y - fMouseDownPos.Y + Height / 2;
      Result := _PosToValue(FTrack.Min, FTrack.Max, FTrack.ViewportSize, Self.Height, FTrack.Height, P.Y, FTrack.FIgnoreViewportSize);
    end;
  end;
end;

{************************************************************}
function TALTrackThumb.GetDefaultTouchTargetExpansion: TRectF;
var DeviceSrv: IFMXDeviceService;
begin
  if SupportsPlatformService(IFMXDeviceService, DeviceSrv) and
    (TDeviceFeature.HasTouchScreen in DeviceSrv.GetFeatures) then
    Result := TRectF.Create(
                DefaultTouchTargetExpansion,
                DefaultTouchTargetExpansion,
                DefaultTouchTargetExpansion,
                DefaultTouchTargetExpansion)
  else
    Result := inherited ;
end;

{*********************************************************************************************}
procedure TALTrackThumb.ScrollCapturedByOtherHandler(const Sender: TObject; const M: TMessage);
begin
  if (Sender = self) then exit;
  {$IFDEF DEBUG}
  //ALLog(
  //  'TALTrackThumb.ScrollCapturedByOtherHandler',
  //  'Captured: ' + ALBoolToStrW(TALScrollCapturedMessage(M).Captured)+ ' | ' +
  //  'Pressed: ' + ALBoolToStrW(FPressed),
  //  TalLogType.verbose);
  {$ENDIF}
  if TALScrollCapturedMessage(M).Captured then begin
    if FPressed then begin
      FPressed := False;
      if (not FValueRange.Tracking) then FValueRange.Tracking := True;
    end;
  end;
end;

{****************************************************************************************}
procedure TALTrackThumb.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  if (Button = TMouseButton.mbLeft) then begin
    BringToFront;
    repaint;
    FPressed := True;
    fMouseDownPos := PointF(X, Y);
    fTrackMouseDownPos := FTrack.AbsoluteToLocal(LocalToAbsolute(fMouseDownPos));
    FTrack.SetFocus;
    fValueRange.Tracking := FTrack.Tracking;
    StartTriggerAnimation(Self, 'Pressed');
    ApplyTriggerEffect(Self, 'Pressed');
  end;
end;

{******************************************************************}
procedure TALTrackThumb.MouseMove(Shift: TShiftState; X, Y: Single);
begin
  inherited;
  if FPressed then begin

    if (not fScrollCapturedByMe) then begin
      var LTrackMousePos := FTrack.AbsoluteToLocal(LocalToAbsolute(TpointF.Create(X,Y)));
      If (((Ftrack.Orientation = TOrientation.Horizontal) and
           (abs(FTrackMouseDownPos.x - LTrackMousePos.x) > abs(FTrackMouseDownPos.y - LTrackMousePos.y)) and
           (abs(FTrackMouseDownPos.x - LTrackMousePos.x) > TALScrollEngine.DefaultTouchSlop)) or
          ((Ftrack.Orientation = TOrientation.Vertical) and
           (abs(FTrackMouseDownPos.y - LTrackMousePos.y) > abs(FTrackMouseDownPos.x - LTrackMousePos.x)) and
           (abs(FTrackMouseDownPos.y - LTrackMousePos.y) > TALScrollEngine.DefaultTouchSlop))) then begin
        fMouseDownPos := PointF(X, Y);
        fTrackMouseDownPos := LTrackMousePos;
        fScrollCapturedByMe := true;
        TMessageManager.DefaultManager.SendMessage(self, TALScrollCapturedMessage.Create(true), True);
      end;
    end;

    if fScrollCapturedByMe then begin
      try
        FValueRange.Value := PointToValue(X, Y);
      except
        FPressed := False;
        raise;
      end;
    end;

  end;
end;

{**************************************************************************************}
procedure TALTrackThumb.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var LValue: Single;
begin
  LValue := PointToValue(X, Y);
  inherited;
  if FPressed then begin

    FScrollCapturedByMe := False;

    FPressed := False;
    try
      if (not FValueRange.Tracking) then begin
        FValueRange.Value := LValue;
        FValueRange.Tracking := True;
      end;
    finally
      StartTriggerAnimation(Self, 'Pressed');
      ApplyTriggerEffect(Self, 'Pressed');
    end;

  end;
end;

{***********************************}
procedure TALTrackThumb.DoMouseLeave;
begin
  inherited;
  if FPressed then begin

    FScrollCapturedByMe := False;

    FPressed := False;
    try
      if (not FValueRange.Tracking) then begin
        FValueRange.Tracking := True;
      end;
    finally
      StartTriggerAnimation(Self, 'Pressed');
      ApplyTriggerEffect(Self, 'Pressed');
    end;

  end;
end;

{********************************************************}
constructor TALTrackBackground.Create(AOwner: TComponent);
begin
  inherited;
  Locked := True;
  HitTest := False;
end;

{*******************************************************}
constructor TALTrackHighlight.Create(AOwner: TComponent);
begin
  inherited;
  Locked := True;
  HitTest := False;
end;

type

  {**************************************}
  TALValueRangeTrack = class (TValueRange)
  private
    FTrack: TALCustomTrack;
    FValueChanged: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoBeforeChange; override;
    procedure DoChanged; override;
    procedure DoAfterChange; override;
    property Track: TALCustomTrack read FTrack;
  end;

{********************************************************}
constructor TALValueRangeTrack.Create(AOwner: TComponent);
begin
  ValidateInheritance(AOwner, TALCustomTrack, false{CanBeNil});
  inherited;
  FTrack := TALCustomTrack(AOwner);
end;

{******************************************}
procedure TALValueRangeTrack.DoBeforeChange;
begin
  FValueChanged := (not SameValue(Value, New.Value));
  inherited;
end;

{*************************************}
procedure TALValueRangeTrack.DoChanged;
begin
  FTrack.Realign;
  FTrack.DoTracking;
  inherited;
end;

{*****************************************}
procedure TALValueRangeTrack.DoAfterChange;
begin
  if FValueChanged then
  try
    FTrack.DoChanged;
  finally
    FValueChanged := False;
  end;
  inherited;
end;

{****************************************************}
constructor TALCustomTrack.Create(AOwner: TComponent);
begin
  inherited;
  //-----
  FValueRange := CreateValueRangeTrack;
  FDefaultValueRange := TBaseValueRange.Create;
  FOrientation := TOrientation.Horizontal;
  FIgnoreViewportSize := false;
  FTracking := True;
  FThumbSize := 0;
  FMinThumbSize := 5;
  FOnChange := nil;
  FOnTracking := nil;
  FBackGround := nil;
  FHighlight := nil;
  FThumb := nil;
end;

{********************************}
destructor TALCustomTrack.Destroy;
begin
  ALFreeAndNil(FDefaultValueRange);
  ALFreeAndNil(FValueRange);
  inherited;
end;

{*****************************************}
procedure TALCustomTrack.AfterConstruction;
begin
  inherited;
  DefaultValueRange.Assign(FValueRange.New);
  realign;
end;

{******************************}
procedure TALCustomTrack.Loaded;
begin
  if not (csDestroying in ComponentState) then begin
    if FValueRange.IsChanged then
      FValueRange.Changed(True);
  end;
  inherited;
end;

{**********************************************************}
function TALCustomTrack.CreateValueRangeTrack : TValueRange;
begin
  Result := TALValueRangeTrack.Create(Self);
end;

{**************************************}
function TALCustomTrack.GetData: TValue;
begin
  Result := Value;
end;

{*************************************************************}
function TALCustomTrack.GetDefaultTouchTargetExpansion: TRectF;
var DeviceSrv: IFMXDeviceService;
begin
  if SupportsPlatformService(IFMXDeviceService, DeviceSrv) and
    (TDeviceFeature.HasTouchScreen in DeviceSrv.GetFeatures) then
    Result := TRectF.Create(
                DefaultTouchTargetExpansion,
                DefaultTouchTargetExpansion,
                DefaultTouchTargetExpansion,
                DefaultTouchTargetExpansion)
  else
    Result := inherited ;
end;

{****************************************************}
procedure TALCustomTrack.SetData(const Value: TValue);
begin
  if Value.IsType<TNotifyEvent> then OnChange := Value.AsType<TNotifyEvent>()
  else if Value.IsOrdinal then Self.Value := Value.AsOrdinal
  else if Value.IsType<Single> then Self.Value := Value.AsType<Single>
  else Self.Value := Min
end;

{*********************************************************************************************}
function TALCustomTrack.GetThumbRect(const Value: single; const aThumb: TALTrackThumb): TRectF;
var Pos, Size: Single;
begin
  Result := LocalRect;
  Size := GetThumbSize(FIgnoreViewportSize);
  case Orientation of
    TOrientation.Horizontal:
      begin
        Pos := _ValueToPos(Min, Max, ViewportSize, Size, Width, Value, FIgnoreViewportSize);
        Size := Size / 2;
        Result := RectF(Pos - Size, 0, Pos + Size, Height);
      end;
    TOrientation.Vertical:
      begin
        Pos := _ValueToPos(Min, Max, ViewportSize, Size, Height, Value, FIgnoreViewportSize);
        Size := Size / 2;
        Result := RectF(0, Pos - Size, Width, Pos + Size);
      end;
  end;
  if (aThumb <> nil) and
     (aThumb.Parent <> nil) and
     (aThumb.Parent is TControl) then begin
   if RectWidth(Result) > TControl(aThumb.Parent).Padding.left +
                           aThumb.Margins.left +
                           TControl(aThumb.Parent).Padding.right -
                           aThumb.Margins.right then begin
      Result.left := Round(Result.left + TControl(aThumb.Parent).Padding.left + aThumb.Margins.left);
      Result.right := Round(Result.right - TControl(aThumb.Parent).Padding.right - aThumb.Margins.right);
    end;
    Result.top := Round(Result.top + TControl(aThumb.Parent).Padding.top + aThumb.Margins.top);
    Result.bottom := Round(Result.bottom - TControl(aThumb.Parent).Padding.bottom - aThumb.Margins.bottom);
  end;
end;

{*****************************************************************************}
function TALCustomTrack.GetThumbSize(var IgnoreViewportSize: Boolean): Integer;
var
  lSize: Double;
begin
  Result := 0;
  case Orientation of
    TOrientation.Horizontal:
      begin
        if ViewportSize > 0 then lSize := ViewportSize / (Max - Min) * Width
        else if SameValue(FThumbSize, 0) then lSize := Height
        else lSize := FThumbSize;
        Result := Round(System.Math.Min(System.Math.MaxValue([lSize, Height / 2, FMinThumbSize]), Width));
      end;
    TOrientation.Vertical:
      begin
        if ViewportSize > 0 then lSize := ViewportSize / (Max - Min) * Height
        else if SameValue(FThumbSize, 0) then lSize := Width
        else lSize := FThumbSize;
        Result := Round(System.Math.Min(System.Math.MaxValue([lSize, Width / 2, FMinThumbSize]), Height));
      end;
  else
    lSize := FMinThumbSize;
  end;
  if Result < FMinThumbSize then Result := 0;
  IgnoreViewportSize := Result <= (lSize - 1);
end;

{*******************************************}
function TALCustomTrack.ValueStored: Boolean;
begin
  Result := not SameValue(Value, DefaultValueRange.Value);
end;

{*********************************************************}
procedure TALCustomTrack.SetThumbSize(const Value: Single);
begin
  if not SameValue(Value, fThumbSize) then begin
    fThumbSize := Value;
    Realign;
  end;
end;

{***********************************************}
function TALCustomTrack.ThumbSizeStored: Boolean;
begin
  Result := (not SameValue(fThumbSize, 0));
end;

{**************************************************}
function TALCustomTrack.ViewportSizeStored: Boolean;
begin
  Result := not SameValue(ViewportSize, DefaultValueRange.ViewportSize);
end;

{***********************************************}
function TALCustomTrack.FrequencyStored: Boolean;
begin
  Result := not SameValue(Frequency, DefaultValueRange.Frequency);
end;

{*****************************************}
function TALCustomTrack.MaxStored: Boolean;
begin
  Result := not SameValue(Max, DefaultValueRange.Max);
end;

{*****************************************}
function TALCustomTrack.MinStored: Boolean;
begin
  Result := not SameValue(Min, DefaultValueRange.Min);
end;

{*************************************}
function TALCustomTrack.GetMax: Double;
begin
  Result := FValueRange.Max;
end;

{***************************************************}
procedure TALCustomTrack.SetMax(const Value: Double);
begin
  if compareValue(Value, Min) < 0 then min := Value;
  FValueRange.Max := Value;
end;

{***************************************************}
procedure TALCustomTrack.SetMin(const Value: Double);
begin
  if compareValue(Value, Max) > 0 then max := Value;
  FValueRange.Min := Value;
end;

{*************************************}
function TALCustomTrack.GetMin: Double;
begin
  Result := FValueRange.Min;
end;

{*********************************************************}
procedure TALCustomTrack.SetFrequency(const Value: Double);
begin
  FValueRange.Frequency := Value;
end;

{*******************************************}
function TALCustomTrack.GetFrequency: Double;
begin
  Result := FValueRange.Frequency;
end;

{***************************************}
function TALCustomTrack.GetValue: Double;
begin
  Result := FValueRange.Value;
end;

{***********************************************}
procedure TALCustomTrack.SetValue(Value: Double);
begin
  FValueRange.Value := Value;
end;

{**********************************************}
function TALCustomTrack.GetViewportSize: Double;
begin
  Result := FValueRange.ViewportSize;
end;

{************************************************************}
procedure TALCustomTrack.SetViewportSize(const Value: Double);
begin
  FValueRange.ViewportSize := Value;
end;

{*******************************************************}
function TALCustomTrack.GetValueRange: TCustomValueRange;
begin
  Result := FValueRange;
end;

{**********************************************************************}
procedure TALCustomTrack.SetValueRange(const AValue: TCustomValueRange);
begin
  FValueRange.Assign(AValue);
end;

{****************************************************************}
procedure TALCustomTrack.SetValueRange_(const Value: TValueRange);
begin
  FValueRange.Assign(Value);
end;

{*********************************}
procedure TALCustomTrack.DoRealign;
var LThumbRect: TRectF;
begin
  inherited;
  if FThumb <> nil then begin
    LThumbRect := GetThumbRect(Value, FThumb);
    FThumb.Visible := not LThumbRect.IsEmpty;
    FThumb.BoundsRect := LThumbRect;
    Repaint;
  end;
  UpdateHighlight;
end;

{***************************************}
procedure TALCustomTrack.UpdateHighlight;
var r: TRectF;
begin
  r := GetThumbRect(Value, FThumb);
  if (FbackGround <> nil) then r.Offset(-fbackground.Margins.Left, -fbackground.Margins.top);
  if FHighlight <> nil then begin
    case Orientation of
      TOrientation.Horizontal: FHighlight.Width := Round((r.Left + r.Right) / 2);
      TOrientation.Vertical: FHighlight.Height := Round((r.Top + r.Bottom) / 2);
    end;
  end;
end;

{*********************************}
procedure TALCustomTrack.DoChanged;
begin
  if not (csLoading in ComponentState) and Assigned(FOnChange) then
    FOnChange(Self);
end;

{**********************************}
procedure TALCustomTrack.DoTracking;
begin
  if not (csLoading in ComponentState) and Assigned(FOnTracking) then
    FOnTracking(Self);
end;

{************************************************************************************************}
procedure TALCustomTrack.KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
var inc: Double;
    LValue: Double;
begin
  inc := Frequency;
  if inc = 0 then inc := 1;
  inherited;
  case Key of
    vkHome: LValue := Min;
    vkEnd: LValue := Max;
    vkUp: LValue := Value - inc;
    vkDown: LValue := Value + inc;
    vkLeft: LValue := Value - inc;
    vkRight: LValue := Value + inc;
    else Exit;
  end;
  Key := 0;
  SetValue(LValue);
end;

{*****************************************************************}
procedure TALCustomTrack.SetOrientation(const Value: TOrientation);
begin
  if FOrientation <> Value then begin
    FOrientation := Value;
    if not (csLoading in ComponentState) then begin
      SetBounds(Position.X, Position.Y, Size.Height, Size.Width);
      if FOrientation=TOrientation.Horizontal then begin
        if FBackGround <> nil then begin
          FBackGround.Align := TalignLayout.none;
          FBackGround.Size.Height := FBackGround.Size.Width;
          FBackGround.Margins.Left := FBackGround.Margins.Top;
          FBackGround.Margins.right := FBackGround.Margins.Bottom;
          FBackGround.Margins.Top := 0;
          FBackGround.Margins.Bottom := 0;
          FBackGround.Align := TalignLayout.VertCenter;
        end;
        //-----
        if FHighlight <> nil then begin
          FHighlight.Size.Height := FBackGround.Size.height;
          FHighlight.Size.Width := 0;
        end;
      end
      else begin
        if FBackGround <> nil then begin
          FBackGround.Align := TalignLayout.none;
          FBackGround.Size.Width := FBackGround.Size.Height;
          FBackGround.Margins.top := FBackGround.Margins.Left;
          FBackGround.Margins.Bottom := FBackGround.Margins.right;
          FBackGround.Margins.left := 0;
          FBackGround.Margins.right := 0;
          FBackGround.Align := TalignLayout.HorzCenter;
        end;
        //-----
        if FHighlight <> nil then begin
          FHighlight.Size.Width := FBackGround.Size.width;
          FHighlight.Size.Height := 0;
        end;
      end;
    end;
  end;
end;

{*********************************************}
function TALCustomTrack.GetIsTracking: Boolean;
begin
  Result := (FThumb <> nil) and FThumb.FPressed;
end;

{*************************************************}
constructor TALTrackBar.Create(AOwner: TComponent);
begin
  inherited;
  CanFocus := True;
  SetAcceptsControls(False);
  //-----
  FBackGround := TALTrackBackground.Create(self);
  FBackGround.Parent := self;
  FBackGround.Stored := False;
  FBackGround.SetSubComponent(True);
  FBackGround.Name := 'BackGround';
  FBackGround.Align := TalignLayout.VertCenter;
  FBackGround.Size.Height := 2;
  FBackGround.Margins.DefaultValue := TrectF.Create(16,0,16,0);
  FBackGround.Margins.Left := 16;
  FBackGround.Margins.right := 16;
  FBackGround.Stroke.Color := TAlphaColors.Null;
  fBackGround.Fill.Color := $ffc5c5c5;
  //-----
  FHighlight := TALTrackHighlight.Create(FBackGround);
  FHighlight.Parent := FBackGround;
  FHighlight.Stored := False;
  FHighlight.SetSubComponent(True);
  FHighlight.Name := 'Highlight';
  FHighlight.Position.Point := TpointF.Create(0,0);
  FHighlight.Size.Height := 2;
  FHighlight.Size.Width := 0;
  FHighlight.Stroke.Color := TalphaColors.Null;
  FHighlight.Fill.Color := $ff167efc;
  //-----
  FThumb := TALTrackThumb.Create(self, fValueRange, true{aWithGlyphObj});
  FThumb.Parent := self;
  FThumb.Stored := False;
  FThumb.SetSubComponent(True);
  FThumb.Name := 'Thumb';
  FThumb.XRadius := 16;
  FThumb.yRadius := 16;
  fThumb.Stroke.Color := $ffd5d5d5;
  FThumb.Fill.Color := $ffffffff;
end;

{******************************************}
function TALTrackBar.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(150, 32);
end;

{**************************************************}
constructor TALScrollBar.Create(AOwner: TComponent);
begin
  inherited;
  CanFocus := False;
  SetAcceptsControls(False);
  //-----
  FThumb := TALTrackThumb.Create(self, FvalueRange, False{aWithGlyphObj});
  FThumb.Parent := self;
  FThumb.Stored := False;
  FThumb.SetSubComponent(True);
  FThumb.Name := 'Thumb';
  FThumb.Stroke.Color := Talphacolors.Null;
  FThumb.Fill.Color := $47000000;
end;

{*******************************************}
function TALScrollBar.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(150, 4);
end;

{******************************************************}
constructor TALRangeTrackBar.Create(AOwner: TComponent);
begin
  inherited;
  FMaxValueRange := CreateValueRangeTrack;
  FMaxValueRange.Value := FMaxValueRange.Max;
  CanFocus := True;
  SetAcceptsControls(False);
  //-----
  FBackGround := TALTrackBackground.Create(self);
  FBackGround.Parent := self;
  FBackGround.Stored := False;
  FBackGround.SetSubComponent(True);
  FBackGround.Name := 'BackGround';
  FBackGround.Align := TalignLayout.VertCenter;
  FBackGround.Size.Height := 2;
  FBackGround.Margins.DefaultValue := TrectF.Create(16,0,16,0);
  FBackGround.Margins.Left := 16;
  FBackGround.Margins.right := 16;
  FBackGround.Stroke.Color := Talphacolors.Null;
  fBackGround.Fill.Color := $ffc5c5c5;
  //-----
  FHighlight := TALTrackHighlight.Create(FBackGround);
  FHighlight.Parent := FBackGround;
  FHighlight.Stored := False;
  FHighlight.SetSubComponent(True);
  FHighlight.Name := 'Highlight';
  FHighlight.Position.Point := TpointF.Create(0,0);
  FHighlight.Size.Height := 2;
  FHighlight.Size.Width := 0;
  FHighlight.Stroke.Color := Talphacolors.Null;
  FHighlight.Fill.Color := $ff167efc;
  //-----
  FThumb := TALTrackThumb.Create(self, FvalueRange, true{aWithGlyphObj});
  FThumb.Parent := self;
  FThumb.Stored := False;
  FThumb.SetSubComponent(True);
  FThumb.Name := 'MinThumb';
  FThumb.XRadius := 16;
  FThumb.yRadius := 16;
  fThumb.Stroke.Color := $ffd5d5d5;
  FThumb.Fill.Color := $ffffffff;
  //-----
  FMaxThumb := TALTrackThumb.Create(self, fMaxValueRange, true{aWithGlyphObj});
  FMaxThumb.Parent := self;
  FMaxThumb.Stored := False;
  FMaxThumb.SetSubComponent(True);
  FMaxThumb.Name := 'MaxThumb';
  FMaxThumb.XRadius := 16;
  FMaxThumb.yRadius := 16;
  fMaxThumb.Stroke.Color := $ffd5d5d5;
  FMaxThumb.Fill.Color := $ffffffff;
end;

{**********************************}
destructor TALRangeTrackBar.Destroy;
begin
  ALFreeAndNil(FMaxValueRange);
  inherited;
end;

{***********************************************}
function TALRangeTrackBar.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(200, 32);
end;

{********************************}
procedure TALRangeTrackBar.Loaded;
begin
  if not (csDestroying in ComponentState) then begin
    if FMaxValueRange.IsChanged then
      FMaxValueRange.Changed(True);
  end;
  inherited;
end;

{***********************************}
procedure TALRangeTrackBar.DoRealign;
var R: TRectF;
begin
  //realign is call be TALValueRangeTrack.DoChanged;
  //so we can check here if minValue <= MaxValue
  if minValue > MaxValue then begin
    if fThumb.Pressed then MinValue := MaxValue
    else MaxValue := MinValue;
    exit; // no need to continue, this function will be called again
  end;
  if FMaxThumb <> nil then begin
    R := GetThumbRect(MaxValue, FMaxThumb);
    FMaxThumb.Visible := not ((R.Right <= R.Left) or (R.Bottom <= R.Top));
    FMaxThumb.BoundsRect := R;
  end;
  inherited DoRealign;
end;

{*****************************************}
procedure TALRangeTrackBar.UpdateHighlight;
var rMin, rMax: TRectF;
begin
  rMin := GetThumbRect(Value, FThumb);
  rMax := GetThumbRect(MaxValue, FMaxThumb);
  if (FbackGround <> nil) then begin
    rMin.Offset(-fbackground.Margins.Left, -fbackground.Margins.top);
    rMax.Offset(-fbackground.Margins.Left, -fbackground.Margins.top);
  end;
  if FHighlight <> nil then begin
    case Orientation of
      TOrientation.Horizontal: begin
        FHighlight.setbounds(
          Round((rMin.Left + rMin.Right) / 2),
          FHighlight.Position.y,
          Round((rMax.Left + rMax.Right) / 2) - Round((rMin.Left + rMin.Right) / 2),
          FHighlight.Height);
      end;
      TOrientation.Vertical: begin
        FHighlight.setbounds(
          FHighlight.Position.x,
          Round((rMin.Top + rMin.Bottom) / 2),
          FHighlight.width,
          Round((rMax.Top + rMax.Bottom) / 2) - Round((rMin.Top + rMin.Bottom) / 2));
      end;
    end;
  end;
end;

{*************************************************}
procedure TALRangeTrackBar.SetValue(Value: Double);
begin
  inherited SetValue(Value);
  if (not fThumb.Pressed) and
     (GetValue > (max - Min) / 2) then fThumb.BringToFront;
end;

{********************************************}
function TALRangeTrackBar.GetMaxValue: Double;
begin
  Result := FMaxValueRange.Value;
end;

{****************************************************}
procedure TALRangeTrackBar.SetMaxValue(Value: Double);
begin
  FMaxValueRange.Value := Value;
  if (not fMaxThumb.Pressed) and
     (GetMaxValue < (max - Min) / 2) then fMaxThumb.BringToFront;
end;

{************************************************}
function TALRangeTrackBar.MaxValueStored: Boolean;
begin
  Result := not SameValue(MaxValue, DefaultValueRange.Value);
end;

{***********************************************************}
procedure TALRangeTrackBar.SetFrequency(const Value: Double);
begin
  inherited;
  FMaxValueRange.Frequency := Value;
end;

{*****************************************************}
procedure TALRangeTrackBar.SetMax(const Value: Double);
begin
  if compareValue(Value, Min) < 0 then min := Value;
  inherited;
  FMaxValueRange.Max := Value;
end;

{*****************************************************}
procedure TALRangeTrackBar.SetMin(const Value: Double);
begin
  if compareValue(Value, Max) > 0 then max := Value;
  inherited;
  FMaxValueRange.Min := Value;
end;

{**************************************************************}
procedure TALRangeTrackBar.SetViewportSize(const Value: Double);
begin
  inherited;
  FMaxValueRange.ViewportSize := Value;
end;

{**********************************************************************************************}
constructor TALBaseCheckBox.TCheckMarkBrush.Create(const ADefaultColor: TAlphaColor);
begin
  inherited Create;
  //--
  FDefaultColor := ADefaultColor;
  FDefaultResourceName := '';
  FDefaultWrapMode := TALImageWrapMode.Fit;
  FDefaultThickness := 2;
  //--
  FColor := FDefaultColor;
  FResourceName := FDefaultResourceName;
  FWrapMode := FDefaultWrapMode;
  FThickness := FDefaultThickness;
  //--
  FMargins := TBounds.Create(TRectF.Create(3,3,3,3));
  FMargins.OnChange := MarginsChanged;
end;

{**************************}
destructor TALBaseCheckBox.TCheckMarkBrush.Destroy;
begin
  ALFreeAndNil(FMargins);
  inherited;
end;

{*********************************}
function TALBaseCheckBox.TCheckMarkBrush.CreateSavedState: TALPersistentObserver;
type
  TCheckMarkBrushClass = class of TCheckMarkBrush;
begin
  result := TCheckMarkBrushClass(classtype).Create(DefaultColor);
end;

{**********************************************}
procedure TALBaseCheckBox.TCheckMarkBrush.Assign(Source: TPersistent);
begin
  if Source is TCheckMarkBrush then begin
    BeginUpdate;
    Try
      Color := TCheckMarkBrush(Source).Color;
      ResourceName := TCheckMarkBrush(Source).ResourceName;
      WrapMode := TCheckMarkBrush(Source).WrapMode;
      Thickness := TCheckMarkBrush(Source).Thickness;
      Margins.Assign(TCheckMarkBrush(Source).Margins);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{************************}
procedure TALBaseCheckBox.TCheckMarkBrush.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Color := DefaultColor;
    ResourceName := DefaultResourceName;
    WrapMode := DefaultWrapMode;
    Thickness := DefaultThickness;
    Margins.Rect := Margins.DefaultValue;
  finally
    EndUpdate;
  end;
end;

{*********************************************************************************}
procedure TALBaseCheckBox.TCheckMarkBrush.Interpolate(const ATo: TCheckMarkBrush; const ANormalizedTime: Single);
begin
  BeginUpdate;
  Try
    if ATo <> nil then begin
      Color := ALInterpolateColor(Color{Start}, ATo.Color{Stop}, ANormalizedTime);
      ResourceName := ATo.ResourceName;
      WrapMode := ATo.WrapMode;
      Thickness := InterpolateSingle(Thickness{Start}, ATo.Thickness{Stop}, ANormalizedTime);
      Margins.Left := InterpolateSingle(Margins.Left{Start}, ATo.Margins.Left{Stop}, ANormalizedTime);
      Margins.Right := InterpolateSingle(Margins.Right{Start}, ATo.Margins.Right{Stop}, ANormalizedTime);
      Margins.Top := InterpolateSingle(Margins.Top{Start}, ATo.Margins.Top{Stop}, ANormalizedTime);
      Margins.Bottom := InterpolateSingle(Margins.Bottom{Start}, ATo.Margins.Bottom{Stop}, ANormalizedTime);
    end
    else begin
      Color := ALInterpolateColor(Color{Start}, DefaultColor{Stop}, ANormalizedTime);
      ResourceName := DefaultResourceName;
      WrapMode := DefaultWrapMode;
      Thickness := InterpolateSingle(Thickness{Start}, DefaultThickness{Stop}, ANormalizedTime);
      Margins.Left := InterpolateSingle(Margins.Left{Start}, Margins.DefaultValue.Left{Stop}, ANormalizedTime);
      Margins.Right := InterpolateSingle(Margins.Right{Start}, Margins.DefaultValue.Right{Stop}, ANormalizedTime);
      Margins.Top := InterpolateSingle(Margins.Top{Start}, Margins.DefaultValue.Top{Stop}, ANormalizedTime);
      Margins.Bottom := InterpolateSingle(Margins.Bottom{Start}, Margins.DefaultValue.Bottom{Stop}, ANormalizedTime);
    end;
  finally
    EndUpdate;
  end;
end;

{*********************************************************************************}
procedure TALBaseCheckBox.TCheckMarkBrush.InterpolateNoChanges(const ATo: TCheckMarkBrush; const ANormalizedTime: Single);
begin
  BeginUpdate;
  Try
    Interpolate(ATo, ANormalizedTime);
  Finally
    EndUpdateNoChanges;
  end;
end;

{************************}
function TALBaseCheckBox.TCheckMarkBrush.HasCheckMark: boolean;
begin
  result := ((Color <> TalphaColors.Null) and
             (CompareValue(FThickness, 0, TEpsilon.Vector) > 0)) or
            (ResourceName <> '');
end;

{***************************************}
function TALBaseCheckBox.TCheckMarkBrush.IsColorStored: Boolean;
begin
  result := FColor <> FDefaultColor;
end;

{**********************************************}
function TALBaseCheckBox.TCheckMarkBrush.IsResourceNameStored: Boolean;
begin
  result := FResourceName <> FDefaultResourceName;
end;

{**********************************************}
function TALBaseCheckBox.TCheckMarkBrush.IsWrapModeStored: Boolean;
begin
  result := FWrapMode <> FDefaultWrapMode;
end;

{****************************************************}
function TALBaseCheckBox.TCheckMarkBrush.IsThicknessStored: Boolean;
begin
  result := not SameValue(FThickness, FDefaultThickness, TEpsilon.Vector);
end;

{****************************************************}
procedure TALBaseCheckBox.TCheckMarkBrush.SetColor(const Value: TAlphaColor);
begin
  if fColor <> Value then begin
    fColor := Value;
    Change;
  end;
end;

{******************************************************}
procedure TALBaseCheckBox.TCheckMarkBrush.SetResourceName(const Value: String);
begin
  if fResourceName <> Value then begin
    fResourceName := Value;
    Change;
  end;
end;

{******************************************************}
procedure TALBaseCheckBox.TCheckMarkBrush.SetWrapMode(const Value: TALImageWrapMode);
begin
  if fWrapMode <> Value then begin
    fWrapMode := Value;
    Change;
  end;
end;

{*********************************************************}
procedure TALBaseCheckBox.TCheckMarkBrush.SetThickness(const Value: Single);
begin
  if not SameValue(Value, FThickness, TEpsilon.Vector) then begin
    fThickness := Value;
    Change;
  end;
end;

{**************************************************}
procedure TALBaseCheckBox.TCheckMarkBrush.SetMargins(const Value: TBounds);
begin
  FMargins.Assign(Value);
end;

{*************************************************}
procedure TALBaseCheckBox.TCheckMarkBrush.MarginsChanged(Sender: TObject);
begin
  change;
end;

{***************************************************************************************************}
constructor TALBaseCheckBox.TInheritCheckMarkBrush.Create(const AParent: TCheckMarkBrush; const ADefaultColor: TAlphaColor);
begin
  inherited create(ADefaultColor);
  FParent := AParent;
  FInherit := True;
  fSuperseded := False;
end;

{*********************************}
function TALBaseCheckBox.TInheritCheckMarkBrush.CreateSavedState: TALPersistentObserver;
type
  TInheritCheckMarkBrushClass = class of TInheritCheckMarkBrush;
begin
  result := TInheritCheckMarkBrushClass(classtype).Create(nil{AParent}, DefaultColor);
end;

{**********************************************************}
procedure TALBaseCheckBox.TInheritCheckMarkBrush.SetInherit(const AValue: Boolean);
begin
  If FInherit <> AValue then begin
    FInherit := AValue;
    Change;
  end;
end;

{****************************************************}
procedure TALBaseCheckBox.TInheritCheckMarkBrush.Assign(Source: TPersistent);
begin
  BeginUpdate;
  Try
    if Source is TInheritCheckMarkBrush then begin
      Inherit := TInheritCheckMarkBrush(Source).Inherit;
      fSuperseded := TInheritCheckMarkBrush(Source).fSuperseded;
    end
    else begin
      Inherit := False;
      fSuperseded := False;
    end;
    inherited Assign(Source);
  Finally
    EndUpdate;
  End;
end;

{******************************}
procedure TALBaseCheckBox.TInheritCheckMarkBrush.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Inherit := True;
    fSuperseded := False;
  finally
    EndUpdate;
  end;
end;

{******************}
procedure TALBaseCheckBox.TInheritCheckMarkBrush.DoSupersede;
begin
  Assign(FParent);
end;

{******************}
procedure TALBaseCheckBox.TInheritCheckMarkBrush.Supersede(Const ASaveState: Boolean = False);
begin
  if ASaveState then SaveState;
  if (FSuperseded) or
     (not inherit) or
     (FParent = nil) then exit;
  beginUpdate;
  try
    var LParentSuperseded := False;
    if FParent is TInheritCheckMarkBrush then begin
      TInheritCheckMarkBrush(FParent).SupersedeNoChanges(true{ASaveState});
      LParentSuperseded := True;
    end;
    try
      DoSupersede;
    finally
      if LParentSuperseded then
        TInheritCheckMarkBrush(FParent).restoreStateNoChanges;
    end;
    Inherit := False;
    FSuperseded := True;
  finally
    EndUpdate;
  end;
end;

{*************************}
procedure TALBaseCheckBox.TInheritCheckMarkBrush.SupersedeNoChanges(Const ASaveState: Boolean = False);
begin
  BeginUpdate;
  try
    Supersede(ASaveState);
  finally
    EndUpdateNoChanges;
  end;
end;

{***********************************}
constructor TALBaseCheckBox.TBaseStateStyle.Create(const AParent: TObject);
begin
  inherited Create(AParent);
  //--
  if StateStyleParent <> nil then FCheckMark := TInheritCheckMarkBrush.Create(StateStyleParent.CheckMark, TAlphaColors.Black{ADefaultColor})
  else if ControlParent <> nil then FCheckMark := TInheritCheckMarkBrush.Create(ControlParent.CheckMark, TAlphaColors.Black{ADefaultColor})
  else FCheckMark := TInheritCheckMarkBrush.Create(nil, TAlphaColors.Black{ADefaultColor});
  FCheckMark.OnChanged := CheckMarkChanged;
  //--
  StateLayer.Margins.DefaultValue := TRectF.Create(-12,-12,-12,-12);
  StateLayer.Margins.Rect := StateLayer.Margins.DefaultValue;
  //--
  StateLayer.DefaultXRadius := -50;
  StateLayer.DefaultYRadius := -50;
  StateLayer.XRadius := StateLayer.DefaultXRadius;
  StateLayer.YRadius := StateLayer.DefaultYRadius;
end;

{*************************************}
destructor TALBaseCheckBox.TBaseStateStyle.Destroy;
begin
  ALFreeAndNil(FCheckMark);
  inherited Destroy;
end;

{******************************************************}
procedure TALBaseCheckBox.TBaseStateStyle.Assign(Source: TPersistent);
begin
  if Source is TBaseStateStyle then begin
    BeginUpdate;
    Try
      CheckMark.Assign(TBaseStateStyle(Source).CheckMark);
      inherited Assign(Source);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{******************************}
procedure TALBaseCheckBox.TBaseStateStyle.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    CheckMark.Reset;
  finally
    EndUpdate;
  end;
end;

{******************************************************}
procedure TALBaseCheckBox.TBaseStateStyle.Interpolate(const ATo: TALBaseStateStyle; const ANormalizedTime: Single);
begin
  {$IF defined(debug)}
  if (ATo <> nil) and (not (ATo is TBaseStateStyle)) then
    Raise Exception.Create('Error F3C72244-894F-4B67-AD86-F24DF5039927');
  {$ENDIF}
  BeginUpdate;
  Try
    inherited Interpolate(ATo, ANormalizedTime);
    if ATo <> nil then CheckMark.Interpolate(TBaseStateStyle(ATo).CheckMark, ANormalizedTime)
    else if StateStyleParent <> nil then begin
      StateStyleParent.SupersedeNoChanges(true{ASaveState});
      try
        CheckMark.Interpolate(StateStyleParent.CheckMark, ANormalizedTime)
      finally
        StateStyleParent.RestoreStateNoChanges;
      end;
    end
    else if ControlParent <> nil then CheckMark.Interpolate(ControlParent.CheckMark, ANormalizedTime)
    else CheckMark.Interpolate(nil, ANormalizedTime);
  Finally
    EndUpdate;
  End;
end;

{******************}
procedure TALBaseCheckBox.TBaseStateStyle.DoSupersede;
begin
  inherited;
  CheckMark.Supersede;
end;

{********************************************************************************}
function TALBaseCheckBox.TBaseStateStyle.GetStateStyleParent: TBaseStateStyle;
begin
  {$IF defined(debug)}
  if (inherited StateStyleParent <> nil) and
     (not (inherited StateStyleParent is TBaseStateStyle)) then
    raise Exception.Create('StateStyleParent must be of type TBaseStateStyle');
  {$ENDIF}
  result := TBaseStateStyle(inherited StateStyleParent);
end;

{***************************************************************}
function TALBaseCheckBox.TBaseStateStyle.GetControlParent: TALBaseCheckBox;
begin
  {$IF defined(debug)}
  if (inherited ControlParent <> nil) and
     (not (inherited ControlParent is TALBaseCheckBox)) then
    raise Exception.Create('ControlParent must be of type TALBaseCheckBox');
  {$ENDIF}
  result := TALBaseCheckBox(inherited ControlParent);
end;

{********************************************************************************}
procedure TALBaseCheckBox.TBaseStateStyle.SetCheckMark(const AValue: TInheritCheckMarkBrush);
begin
  FCheckMark.Assign(AValue);
end;

{***********************************************}
function TALBaseCheckBox.TBaseStateStyle.GetInherit: Boolean;
begin
  Result := inherited GetInherit and
            CheckMark.Inherit;
end;

{*****************************************************************}
procedure TALBaseCheckBox.TBaseStateStyle.CheckMarkChanged(ASender: TObject);
begin
  Change;
end;

{**********************************************************}
function TALBaseCheckBox.TDisabledStateStyle.IsOpacityStored: Boolean;
begin
  Result := not SameValue(FOpacity, TControl.DefaultDisabledOpacity, TEpsilon.Scale);
end;

{********************************************************************}
procedure TALBaseCheckBox.TDisabledStateStyle.SetOpacity(const Value: Single);
begin
  if not SameValue(FOpacity, Value, TEpsilon.Scale) then begin
    FOpacity := Value;
    Change;
  end;
end;

{***********************************************************************}
constructor TALBaseCheckBox.TDisabledStateStyle.Create(const AParent: TObject);
begin
  inherited Create(AParent);
  FOpacity := TControl.DefaultDisabledOpacity;
end;

{****************************************************************}
procedure TALBaseCheckBox.TDisabledStateStyle.Assign(Source: TPersistent);
begin
  BeginUpdate;
  Try
    if Source is TDisabledStateStyle then
      Opacity := TDisabledStateStyle(Source).Opacity
    else
      Opacity := TControl.DefaultDisabledOpacity;
    inherited Assign(Source);
  Finally
    EndUpdate;
  End;
end;

{******************************}
procedure TALBaseCheckBox.TDisabledStateStyle.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Opacity := TControl.DefaultDisabledOpacity;
  finally
    EndUpdate;
  end;
end;

{******************************}
function TALBaseCheckBox.TDisabledStateStyle.GetInherit: Boolean;
begin
  // Opacity is not part of the GetInherit function because it updates the
  // disabledOpacity of the base control immediately every time it changes.
  // Essentially, it acts merely as a link to the disabledOpacity of the base control.
  Result := inherited GetInherit;
end;

{*************************************}
constructor TALBaseCheckBox.TCheckStateStyles.Create(const AParent: TALBaseCheckBox);
begin
  inherited Create;
  //--
  FDefault := TDefaultStateStyle.Create(AParent);
  FDefault.OnChanged := DefaultChanged;
  //--
  FDisabled := TDisabledStateStyle.Create(FDefault);
  FDisabled.OnChanged := DisabledChanged;
  //--
  FHovered := THoveredStateStyle.Create(FDefault);
  FHovered.OnChanged := HoveredChanged;
  //--
  FPressed := TPressedStateStyle.Create(FDefault);
  FPressed.OnChanged := PressedChanged;
  //--
  FFocused := TFocusedStateStyle.Create(FDefault);
  FFocused.OnChanged := FocusedChanged;
end;

{*************************************}
destructor TALBaseCheckBox.TCheckStateStyles.Destroy;
begin
  ALFreeAndNil(FDefault);
  ALFreeAndNil(FDisabled);
  ALFreeAndNil(FHovered);
  ALFreeAndNil(FPressed);
  ALFreeAndNil(FFocused);
  inherited Destroy;
end;

{*********************************}
function TALBaseCheckBox.TCheckStateStyles.CreateSavedState: TALPersistentObserver;
type
  TCheckStateStylesClass = class of TCheckStateStyles;
begin
  result := TCheckStateStylesClass(classtype).Create(nil{AParent});
end;

{******************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.Assign(Source: TPersistent);
begin
  if Source is TCheckStateStyles then begin
    BeginUpdate;
    Try
      Default.Assign(TCheckStateStyles(Source).Default);
      Disabled.Assign(TCheckStateStyles(Source).Disabled);
      Hovered.Assign(TCheckStateStyles(Source).Hovered);
      Pressed.Assign(TCheckStateStyles(Source).Pressed);
      Focused.Assign(TCheckStateStyles(Source).Focused);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{******************************}
procedure TALBaseCheckBox.TCheckStateStyles.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Default.Reset;
    Disabled.Reset;
    Hovered.Reset;
    Pressed.Reset;
    Focused.Reset;
  finally
    EndUpdate;
  end;
end;

{******************************}
procedure TALBaseCheckBox.TCheckStateStyles.ClearBufDrawable;
begin
  Default.ClearBufDrawable;
  Disabled.ClearBufDrawable;
  Hovered.ClearBufDrawable;
  Pressed.ClearBufDrawable;
  Focused.ClearBufDrawable;
end;

{************************************************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.SetDefault(const AValue: TDefaultStateStyle);
begin
  FDefault.Assign(AValue);
end;

{************************************************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.SetDisabled(const AValue: TDisabledStateStyle);
begin
  FDisabled.Assign(AValue);
end;

{************************************************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.SetHovered(const AValue: THoveredStateStyle);
begin
  FHovered.Assign(AValue);
end;

{*******************************************************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.SetPressed(const AValue: TPressedStateStyle);
begin
  FPressed.Assign(AValue);
end;

{*******************************************************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.SetFocused(const AValue: TFocusedStateStyle);
begin
  FFocused.Assign(AValue);
end;

{**********************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.DefaultChanged(ASender: TObject);
begin
  Change;
end;

{**********************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.DisabledChanged(ASender: TObject);
begin
  Change;
end;

{************************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.HoveredChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.PressedChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
procedure TALBaseCheckBox.TCheckStateStyles.FocusedChanged(ASender: TObject);
begin
  Change;
end;

{*************************************}
constructor TALBaseCheckBox.TStateStyles.Create(const AParent: TALBaseCheckBox);
begin
  inherited Create(AParent);
  //--
  FChecked := TCheckStateStyles.Create(AParent);
  FChecked.OnChanged := CheckedChanged;
  //--
  FUnchecked := TCheckStateStyles.Create(AParent);
  FUnchecked.OnChanged := UncheckedChanged;
end;

{*************************************}
destructor TALBaseCheckBox.TStateStyles.Destroy;
begin
  ALFreeAndNil(FChecked);
  ALFreeAndNil(FUnchecked);
  inherited Destroy;
end;

{*********************************}
function TALBaseCheckBox.TStateStyles.CreateSavedState: TALPersistentObserver;
type
  TStateStylesClass = class of TStateStyles;
begin
  result := TStateStylesClass(classtype).Create(nil{AParent});
end;

{******************************************************}
procedure TALBaseCheckBox.TStateStyles.Assign(Source: TPersistent);
begin
  if Source is TStateStyles then begin
    BeginUpdate;
    Try
      Checked.Assign(TStateStyles(Source).Checked);
      Unchecked.Assign(TStateStyles(Source).Unchecked);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{******************************}
procedure TALBaseCheckBox.TStateStyles.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Checked.reset;
    Unchecked.reset;
  finally
    EndUpdate;
  end;
end;

{******************************}
procedure TALBaseCheckBox.TStateStyles.ClearBufDrawable;
begin
  inherited;
  Checked.ClearBufDrawable;
  Unchecked.ClearBufDrawable;
end;

{*******************************************************}
function TALBaseCheckBox.TStateStyles.GetCurrentRawStyle: TALBaseStateStyle;
begin
  if Parent.Checked then begin
    if Not Parent.Enabled then Result := Checked.Disabled
    else if Parent.Pressed then Result := Checked.Pressed
    else if Parent.IsFocused then Result := Checked.Focused
    else if Parent.IsMouseOver then Result := Checked.Hovered
    else result := Checked.Default;
  end
  else begin
    if Not Parent.Enabled then Result := UnChecked.Disabled
    else if Parent.Pressed then Result := UnChecked.Pressed
    else if Parent.IsFocused then Result := UnChecked.Focused
    else if Parent.IsMouseOver then Result := UnChecked.Hovered
    else result := UnChecked.Default;
  end;
end;

{************************************************************************************}
function TALBaseCheckBox.TStateStyles.GetParent: TALBaseCheckBox;
begin
  Result := TALBaseCheckBox(inherited Parent);
end;

{************************************************************************************}
procedure TALBaseCheckBox.TStateStyles.SetChecked(const AValue: TCheckStateStyles);
begin
  FChecked.Assign(AValue);
end;

{*********************************************************************************}
procedure TALBaseCheckBox.TStateStyles.SetUnchecked(const AValue: TCheckStateStyles);
begin
  FUnchecked.Assign(AValue);
end;

{**********************************************************}
procedure TALBaseCheckBox.TStateStyles.CheckedChanged(ASender: TObject);
begin
  Change;
end;

{**********************************************************}
procedure TALBaseCheckBox.TStateStyles.UncheckedChanged(ASender: TObject);
begin
  Change;
end;

{*************************************************}
constructor TALBaseCheckBox.Create(AOwner: TComponent);
begin
  inherited;
  //--
  SetAcceptsControls(False);
  CanFocus := True;
  Cursor := crHandPoint;
  //--
  var LFillChanged: TNotifyEvent := fill.OnChanged;
  fill.OnChanged := nil;
  Fill.DefaultColor := TAlphaColors.White;
  Fill.Color := Fill.DefaultColor;
  fill.OnChanged := LFillChanged;
  //--
  var LStrokeChanged: TNotifyEvent := stroke.OnChanged;
  stroke.OnChanged := Nil;
  Stroke.DefaultColor := TAlphaColors.Black;
  Stroke.Color := Stroke.DefaultColor;
  stroke.OnChanged := LStrokeChanged;
  //--
  FCheckMark := TCheckMarkBrush.Create(TAlphaColors.Black);
  FCheckMark.OnChanged := CheckMarkChanged;
  //--
  FChecked := False;
  FDoubleBuffered := true;
  FDefaultXRadius := 0;
  FDefaultYRadius := 0;
  FXRadius := FDefaultXRadius;
  FYRadius := FDefaultYRadius;
  FOnChange := nil;
  //--
  // Must be created at the end because it requires FCheckMark to
  // be already created.
  FStateStyles := CreateStateStyles;
  FStateStyles.OnChanged := StateStylesChanged;
end;

{*****************************}
destructor TALBaseCheckBox.Destroy;
begin
  ALFreeAndNil(FStateStyles);
  ALFreeAndNil(FCheckMark);
  inherited;
end;

{*******************************************************}
function TALBaseCheckBox.CreateStateStyles: TStateStyles;
begin
  Result := TStateStyles.Create(self);
end;

{***********************************************}
function TALBaseCheckBox.GetDoubleBuffered: boolean;
begin
  result := fDoubleBuffered;
end;

{**************************************************************}
procedure TALBaseCheckBox.SetDoubleBuffered(const AValue: Boolean);
begin
  if AValue <> fDoubleBuffered then begin
    fDoubleBuffered := AValue;
    if not fDoubleBuffered then clearBufDrawable;
  end;
end;

{***************************************}
function TALBaseCheckBox.GetChecked: Boolean;
begin
  Result := FChecked;
end;

{*****************************************************}
procedure TALBaseCheckBox.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then begin
    FChecked := Value;
    if FChecked then DisabledOpacity := StateStyles.Checked.Disabled.opacity
    else DisabledOpacity := StateStyles.Unchecked.Disabled.opacity;
    DoChanged;
  end;
end;

{***********************************************************}
procedure TALBaseCheckBox.SetCheckMark(const Value: TCheckMarkBrush);
begin
  FCheckMark.Assign(Value);
end;

{*********************************************************************}
procedure TALBaseCheckBox.SetStateStyles(const AValue: TStateStyles);
begin
  FStateStyles.Assign(AValue);
end;

{**************************************************}
function TALBaseCheckBox.IsXRadiusStored: Boolean;
begin
  Result := not SameValue(FXRadius, FDefaultXRadius, TEpsilon.Vector);
end;

{**************************************************}
function TALBaseCheckBox.IsYRadiusStored: Boolean;
begin
  Result := not SameValue(FYRadius, FDefaultYRadius, TEpsilon.Vector);
end;

{****************************************************}
procedure TALBaseCheckBox.SetXRadius(const Value: Single);
var
  NewValue: Single;
begin
  if csDesigning in ComponentState then NewValue := Max(-50, Min(Value, Min(Width / 2, Height / 2)))
  else NewValue := Value;
  if not SameValue(FXRadius, NewValue, TEpsilon.Vector) then begin
    clearBufDrawable;
    FXRadius := NewValue;
    Repaint;
  end;
end;

{****************************************************}
procedure TALBaseCheckBox.SetYRadius(const Value: Single);
var
  NewValue: Single;
begin
  if csDesigning in ComponentState then NewValue := Max(-50, Min(Value, Min(Width / 2, Height / 2)))
  else NewValue := Value;
  if not SameValue(FYRadius, NewValue, TEpsilon.Vector) then begin
    clearBufDrawable;
    FYRadius := NewValue;
    Repaint;
  end;
end;

{******************************************************}
procedure TALBaseCheckBox.CheckMarkChanged(Sender: TObject);
begin
  clearBufDrawable;
  Repaint;
end;

{**************************************************}
procedure TALBaseCheckBox.FillChanged(Sender: TObject);
begin
  clearBufDrawable;
  inherited;
end;

{****************************************************}
procedure TALBaseCheckBox.StrokeChanged(Sender: TObject);
begin
  clearBufDrawable;
  inherited;
end;

{****************************************************}
procedure TALBaseCheckBox.ShadowChanged(Sender: TObject);
begin
  clearBufDrawable;
  inherited;
end;

{******************************************************}
procedure TALBaseCheckBox.StateStylesChanged(Sender: TObject);
begin
  clearBufDrawable;
  if Checked then DisabledOpacity := StateStyles.Checked.Disabled.opacity
  else DisabledOpacity := StateStyles.Unchecked.Disabled.opacity;
  Repaint;
end;

{**************************************************}
procedure TALBaseCheckBox.IsMouseOverChanged;
begin
  inherited;
  StateStyles.startTransition;
  repaint;
end;

{********************************************}
procedure TALBaseCheckBox.IsFocusedChanged;
begin
  inherited;
  StateStyles.startTransition;
  repaint;
end;

{**************************************************}
procedure TALBaseCheckBox.PressedChanged;
begin
  inherited;
  StateStyles.startTransition;
  repaint;
end;

{*********************************************************************************************}
procedure TALBaseCheckBox.KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
begin
  inherited;
  if (KeyChar = ' ') then begin
    Click; // Emulate mouse click to perform Action.OnExecute
    KeyChar := #0;
  end;
end;

{*****************************}
procedure TALBaseCheckBox.Click;
begin
  Checked := not Checked;
  inherited;
end;

{******************************************}
function TALBaseCheckBox.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(18, 18);
end;

{******************************}
procedure TALBaseCheckBox.DoChanged;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
  Repaint;
end;

{******************************}
procedure TALBaseCheckBox.DoResized;
begin
  ClearBufDrawable;
  inherited;
end;

{***********************************}
procedure TALBaseCheckBox.clearBufDrawable;
begin
  {$IFDEF debug}
  if (FStateStyles <> nil) and
     (not (csDestroying in ComponentState)) and
     ((not ALIsDrawableNull(FStateStyles.Checked.Default.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Checked.Disabled.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Checked.Hovered.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Checked.Pressed.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Checked.Focused.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Default.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Disabled.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Hovered.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Pressed.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Focused.BufDrawable))) then
    ALLog(Classname + '.clearBufDrawable', 'BufDrawable has been cleared | Name: ' + Name, TalLogType.warn);
  {$endif}
  if FStateStyles <> nil then
    FStateStyles.ClearBufDrawable;
end;

{************************************}
procedure TALBaseCheckBox.MakeBufDrawable;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  function _DoMakeBufDrawable(const AStateStyle: TBaseStateStyle): boolean;
  begin
    if (not ALIsDrawableNull(AStateStyle.BufDrawable)) then exit(False);
    AStateStyle.SupersedeNoChanges(true{ASaveState});
    try
      CreateBufDrawable(
        AStateStyle.BufDrawable, // var ABufDrawable: TALDrawable;
        AStateStyle.BufDrawableRect, // var ABufDrawableRect: TRectF;
        AStateStyle.Fill, // const AFill: TALBrush;
        AStateStyle.StateLayer, // const AStateLayer: TALStateLayer;
        AStateStyle.Stroke, // const AStroke: TALStrokeBrush;
        AStateStyle.CheckMark, // const ACheckMark: TCheckMarkBrush;
        AStateStyle.Shadow); // const AShadow: TALShadow);
    finally
      AStateStyle.RestorestateNoChanges;
    end;
    Result := True;
  end;

begin
  //--- Do not create BufDrawable if we are in the middle of a transition
  if StateStyles.IsTransitionAnimationRunning then
    exit;
  //--- Do not create BufDrawable if not DoubleBuffered
  if {$IF not DEFINED(ALDPK)}(not DoubleBuffered){$ELSE}False{$ENDIF} then begin
    clearBufDrawable;
    exit;
  end;
  //--
  if Checked then _DoMakeBufDrawable(StateStyles.Checked.Default)
  else _DoMakeBufDrawable(StateStyles.UnChecked.Default);
  //--
  var LStateStyle := TBaseStateStyle(StateStyles.GetCurrentRawStyle);
  if LStateStyle = nil then exit;
  if LStateStyle.Inherit then exit;
  _DoMakeBufDrawable(LStateStyle);
  // No need to center LStateStyle.BufDrawableRect on the main BufDrawableRect
  // because BufDrawableRect always has the width and height of the localRect.
end;

{**********************************}
procedure TALBaseCheckBox.DrawCheckMark(
            const ACanvas: TALCanvas;
            const AScale: Single;
            const ADstRect: TrectF;
            const AChecked: Boolean;
            const ACheckMark: TCheckMarkBrush);
begin

  var LRect := ADstRect;
  LRect.Top := LRect.Top * AScale;
  LRect.right := LRect.right * AScale;
  LRect.left := LRect.left * AScale;
  LRect.bottom := LRect.bottom * AScale;
  var LScaledMarginsRect := ACheckMark.Margins.Rect;
  LScaledMarginsRect.Left := LScaledMarginsRect.Left * AScale;
  LScaledMarginsRect.right := LScaledMarginsRect.right * AScale;
  LScaledMarginsRect.top := LScaledMarginsRect.top * AScale;
  LScaledMarginsRect.bottom := LScaledMarginsRect.bottom * AScale;
  LRect.Top := LRect.Top + LScaledMarginsRect.top;
  LRect.right := LRect.right - LScaledMarginsRect.right;
  LRect.left := LRect.left + LScaledMarginsRect.left;
  LRect.bottom := LRect.bottom - LScaledMarginsRect.bottom;
  if LRect.IsEmpty then exit;

  // Without ResourceName
  if ACheckMark.ResourceName = '' then begin

    // Exit if no color or no stroke
    var LScaledCheckMarkThickness := ACheckMark.Thickness * AScale;
    if (ACheckMark.Color = TalphaColors.Null) or (CompareValue(LScaledCheckMarkThickness, 0, TEpsilon.position) <= 0) then
      exit;

    // exit if not checked
    if not Achecked then
      exit;

    // Try to find LPoint2.x so that LPoint1, LPoint2 and LPoint3 form
    // a right triangle
    Var LHalfScaledCheckMarkThickness := ((LScaledCheckMarkThickness / Sqrt(2)) / 2);
    Var LCheckMarkRect := TRectF.Create(0,0,342,270).FitInto(Lrect);
    var LPoint1 := TPointF.Create(LCheckMarkRect.left + LHalfScaledCheckMarkThickness, LCheckMarkRect.top+(LCheckMarkRect.height * 0.5));
    var LPoint2 := TPointF.Create(0, LCheckMarkRect.Bottom - (2*LHalfScaledCheckMarkThickness));
    var LPoint3 := TPointF.Create(LCheckMarkRect.right-LHalfScaledCheckMarkThickness, LCheckMarkRect.top+LHalfScaledCheckMarkThickness);
    // Coefficients for the quadratic equation ax^2 + bx + c = 0
    var a: Single := 1;
    var b: Single := -(LPoint1.X + LPoint3.X);
    var c: Single := LPoint1.X * LPoint3.X + LPoint1.Y * LPoint3.Y - LPoint1.Y * LPoint2.Y - LPoint2.Y * LPoint3.Y + Sqr(LPoint2.Y);
    // Calculate the discriminant
    var LDiscriminant: Single := b * b - 4 * a * c;
    // Check if there are real solutions
    if LDiscriminant < 0 then begin
      // No real solution so use place LPoint2.x
      // at 33% from the left border
      LPoint2.x := LCheckMarkRect.Left + (LCheckMarkRect.Width * 0.33);
    end
    else begin
      // 2 solutions:
      //     (-b - Sqrt(LDiscriminant)) / (2 * a);
      //     (-b + Sqrt(LDiscriminant)) / (2 * a);
      // Use only the first one
      LPoint2.x := (-b - Sqrt(LDiscriminant)) / (2 * a);
    end;

    {$REGION 'SKIA'}
    {$IF defined(ALSkiaEngine)}

    // Create LPaint
    var LPaint := ALSkCheckHandle(sk4d_paint_create);
    try

      // Requests, but does not require, that edge pixels draw opaque or with partial transparency.
      sk4d_paint_set_antialias(LPaint, true);
      // Sets whether the geometry is filled, stroked, or filled and stroked.
      sk4d_paint_set_dither(LPaint, true);

      // Stroke with solid color
      sk4d_paint_set_style(LPaint, sk_paintstyle_t.STROKE_SK_PAINTSTYLE);
      sk4d_paint_set_stroke_width(LPaint, LScaledCheckMarkThickness);
      sk4d_paint_set_color(LPaint, ACheckMark.Color);
      var LPathBuilder := ALSkCheckHandle(sk4d_pathbuilder_create);
      try
        sk4d_pathbuilder_move_to(LPathBuilder, @LPoint1);
        sk4d_pathbuilder_line_to(LPathBuilder, @LPoint2);
        sk4d_pathbuilder_line_to(LPathBuilder, @LPoint3);
        var LPath := sk4d_pathbuilder_detach(LPathBuilder);
        try
          sk4d_canvas_draw_Path(ACanvas, LPath, LPaint);
        finally
          sk4d_path_destroy(LPath);
        end;
      finally
        sk4d_pathbuilder_destroy(LPathBuilder);
      end;

    finally
      sk4d_paint_destroy(LPaint);
    end;

    {$ENDIF}
    {$ENDREGION}

    {$REGION 'ANDROID'}
    {$IF (defined(ANDROID)) and (not defined(ALSkiaEngine))}

    // Create LPaint
    var LPaint := TJPaint.JavaClass.init;
    LPaint.setAntiAlias(true); // Enabling this flag will cause all draw operations that support antialiasing to use it.
    LPaint.setFilterBitmap(True); // enable bilinear sampling on scaled bitmaps. If cleared, scaled bitmaps will be drawn with nearest neighbor sampling, likely resulting in artifacts.
    LPaint.setDither(true); // Enabling this flag applies a dither to any blit operation where the target's colour space is more constrained than the source.

    // Stroke with solid color
    LPaint.setStyle(TJPaint_Style.JavaClass.STROKE);
    LPaint.setStrokeWidth(LScaledCheckMarkThickness);
    LPaint.setColor(integer(ACheckMark.Color));
    var LPath := TJPath.Create;
    LPath.moveTo(LPoint1.x, LPoint1.y);
    LPath.LineTo(LPoint2.x, LPoint2.y);
    LPath.LineTo(LPoint3.x, LPoint3.y);
    aCanvas.drawPath(LPath,LPaint);
    LPath := nil;

    //free the paint
    LPaint := nil;

    {$ENDIF}
    {$ENDREGION}

    {$REGION 'APPLEOS'}
    {$IF (defined(ALAppleOS)) and (not defined(ALSkiaEngine))}

    var LAlphaColor := TAlphaColorCGFloat.Create(ACheckMark.Color);
    CGContextSetRGBStrokeColor(ACanvas, LAlphaColor.R, LAlphaColor.G, LAlphaColor.B, LAlphaColor.A);
    CGContextSetLineWidth(ACanvas, LScaledCheckMarkThickness);

    var LGridHeight := CGBitmapContextGetHeight(ACanvas);

    CGContextBeginPath(ACanvas);
    CGContextMoveToPoint(ACanvas, LPoint1.x, LGridHeight - LPoint1.y);
    CGContextAddLineToPoint(ACanvas, LPoint2.x, LGridHeight - LPoint2.y);
    CGContextAddLineToPoint(ACanvas, LPoint3.x, LGridHeight - LPoint3.y);
    CGContextStrokePath(ACanvas);


    {$ENDIF}
    {$ENDREGION}

    {$REGION 'MSWINDOWS'}
    {$IF (not defined(ANDROID)) and (not defined(ALAppleOS)) and (not defined(ALSkiaEngine))}

    var LSaveState := ACanvas.SaveState;
    try
      ACanvas.Stroke.Color := ACheckMark.Color;
      ACanvas.Stroke.Thickness := LScaledCheckMarkThickness;
      ACanvas.DrawLine(LPoint1, LPoint2, 1{AOpacity});
      ACanvas.DrawLine(LPoint2, LPoint3, 1{AOpacity});
    finally
      ACanvas.RestoreState(LSaveState)
    end;

    {$ENDIF}
    {$ENDREGION}

  end

  // With ResourceName
  else begin

    ALDrawRectangle(
      ACanvas, // const ACanvas: TALCanvas;
      1, // const AScale: Single;
      LRect, // const ADstRect: TrectF;
      1, // const AOpacity: Single;
      ACheckMark.Color, // const AFillColor: TAlphaColor;
      TGradientStyle.Linear, // const AFillGradientStyle: TGradientStyle;
      [], // const AFillGradientColors: TArray<TAlphaColor>;
      [], // const AFillGradientOffsets: TArray<Single>;
      TPointF.Zero, // const AFillGradientStartPoint: TPointF; // Coordinates in ADstRect space. You can use ALGetLinearGradientCoordinates to convert angle to point
      TPointF.Zero, // const AFillGradientEndPoint: TPointF; // Coordinates in ADstRect space. You can use ALGetLinearGradientCoordinates to convert angle to point
      ACheckMark.ResourceName, // const AFillResourceName: String;
      ACheckMark.WrapMode, // Const AFillWrapMode: TALImageWrapMode;
      TRectF.Empty, // Const AFillBackgroundMarginsRect: TRectF;
      TRectF.Empty, // Const AFillImageMarginsRect: TRectF;
      0, // const AStateLayerOpacity: Single;
      TAlphaColors.Null, // const AStateLayerColor: TAlphaColor;
      TRectF.Empty, // Const AStateLayerMarginsRect: TRectF;
      0, // const AStateLayerXRadius: Single;
      0, // const AStateLayerYRadius: Single;
      False, // const ADrawStateLayerOnTop: Boolean;
      TAlphaColors.Null, // const AStrokeColor: TalphaColor;
      0, // const AStrokeThickness: Single;
      TAlphaColors.Null, // const AShadowColor: TAlphaColor; // If ShadowColor is not null, the Canvas should have adequate space to accommodate the shadow. You can use the ALGetShadowWidth function to estimate the required width.
      0, // const AShadowBlur: Single;
      0, // const AShadowOffsetX: Single;
      0, // const AShadowOffsetY: Single;
      AllSides, // const ASides: TSides;
      AllCorners, // const ACorners: TCorners;
      0, // const AXRadius: Single;
      0); // const AYRadius: Single)

  end;

end;

{**************************************}
Procedure TALBaseCheckBox.CreateBufDrawable(
            var ABufDrawable: TALDrawable;
            out ABufDrawableRect: TRectF;
            const AFill: TALBrush;
            const AStateLayer: TALStateLayer;
            const AStroke: TALStrokeBrush;
            const ACheckMark: TCheckMarkBrush;
            const AShadow: TALShadow);
begin

  if (not ALIsDrawableNull(ABufDrawable)) then exit;

  ABufDrawableRect := LocalRect;
  var LSurfaceRect := ALGetShapeSurfaceRect(
                        ABufDrawableRect, // const ARect: TRectF;
                        AFill, // const AFill: TALBrush;
                        AStateLayer, // const AStateLayer: TALStateLayer;
                        AShadow); // const AShadow: TALShadow): TRectF;
  if ACheckMark.HasCheckMark then begin
    var LCheckMarkRect := ABufDrawableRect;
    LCheckMarkRect.Inflate(-ACheckMark.margins.Left, -ACheckMark.margins.top, -ACheckMark.margins.right, -ACheckMark.margins.Bottom);
    LSurfaceRect := TRectF.Union(LCheckMarkRect, LSurfaceRect);
  end;
  LSurfaceRect := ALAlignDimensionToPixelCeil(LSurfaceRect, ALGetScreenScale, TEpsilon.Position); // To obtain a drawable with pixel-aligned width and height
  ABufDrawableRect.Offset(-LSurfaceRect.Left, -LSurfaceRect.Top);

  var LSurface: TALSurface;
  var LCanvas: TALCanvas;
  ALCreateSurface(
    LSurface, // out ASurface: TALSurface;
    LCanvas, // out ACanvas: TALCanvas;
    ALGetScreenScale, // const AScale: Single;
    LSurfaceRect.Width, // const w: integer;
    LSurfaceRect.height);// const h: integer)
  try

    if ALCanvasBeginScene(LCanvas) then
    try

      ALDrawRectangle(
        LCanvas, // const ACanvas: TALCanvas;
        ALGetScreenScale, // const AScale: Single;
        ABufDrawableRect, // const Rect: TrectF;
        1, // const AOpacity: Single;
        AFill, // const Fill: TALBrush;
        AStateLayer, // const StateLayer: TALStateLayer;
        ACheckMark.Color, // const AStateLayerContentColor: TAlphaColor;
        False, // const ADrawStateLayerOnTop: Boolean;
        AStroke, // const Stroke: TALStrokeBrush;
        AShadow, // const Shadow: TALShadow
        AllSides, // const Sides: TSides;
        AllCorners, // const Corners: TCorners;
        XRadius, // const XRadius: Single = 0;
        YRadius); // const YRadius: Single = 0);

      DrawCheckMark(
        LCanvas, // const ACanvas: TALCanvas;
        ALGetScreenScale, // const AScale: Single;
        ABufDrawableRect, // const ADstRect: TrectF;
        Checked, // const AChecked: Boolean
        ACheckMark); // const ACheckMark: TCheckMarkBrush;

    finally
      ALCanvasEndScene(LCanvas)
    end;

    ABufDrawable := ALCreateDrawableFromSurface(LSurface);
    // The Shadow or Statelayer are not included in the dimensions of the fBufDrawableRect rectangle.
    // However, the fBufDrawableRect rectangle is offset by the dimensions of the shadow/Statelayer.
    ABufDrawableRect.Offset(-2*ABufDrawableRect.Left, -2*ABufDrawableRect.Top);

  finally
    ALFreeAndNilSurface(LSurface, LCanvas);
  end;

end;

{**************************}
procedure TALBaseCheckBox.Paint;
begin

  StateStyles.UpdateLastPaintedRawStyle;
  MakeBufDrawable;

  var LDrawable: TALDrawable;
  var LDrawableRect: TRectF;
  if StateStyles.IsTransitionAnimationRunning then begin
    LDrawable := ALNullDrawable;
    LDrawableRect := TRectF.Empty;
  end
  else begin
    var LStateStyle := TBaseStateStyle(StateStyles.GetCurrentRawStyle);
    if LStateStyle <> nil then begin
      LDrawable := LStateStyle.BufDrawable;
      LDrawableRect := LStateStyle.BufDrawableRect;
      if ALIsDrawableNull(LDrawable) then begin
        if checked then begin
          LDrawable := StateStyles.Checked.default.BufDrawable;
          LDrawableRect := StateStyles.Checked.default.BufDrawableRect;
        end
        else begin
          LDrawable := StateStyles.UnChecked.default.BufDrawable;
          LDrawableRect := StateStyles.UnChecked.default.BufDrawableRect;
        end;
      end;
    end
    else
      raise Exception.Create('Error #EA9B4064-F1D2-4E04-82FE-99FD3ED8B1F3');
  end;

  if ALIsDrawableNull(LDrawable) then begin

    var LCurrentAdjustedStateStyle := TBaseStateStyle(StateStyles.GetCurrentAdjustedStyle);
    if LCurrentAdjustedStateStyle = nil then begin
      inherited Paint;
      exit;
    end;

    var LCanvasSaveState: TCanvasSaveState := ALScaleAndCenterCanvas(
                                                Canvas, // Const ACanvas: TCanvas;
                                                AbsoluteRect, // Const AAbsoluteRect: TRectF;
                                                LCurrentAdjustedStateStyle.Scale.x, // Const AScaleX: Single;
                                                LCurrentAdjustedStateStyle.Scale.y, // Const AScaleY: Single;
                                                true); // Const ASaveState: Boolean);
    try

      {$IF DEFINED(ALSkiaCanvas)}

      // Canvas.AlignToPixel is used because when we call ALDrawDrawable,
      // we do LDstRect := ACanvas.AlignToPixel(LDstRect).
      // Therefore, when drawing directly on the canvas,
      // we must draw at the exact same position as when we call ALDrawDrawable.
      var LRect := Canvas.AlignToPixel(LocalRect);

      if compareValue(AbsoluteOpacity, 1, Tepsilon.Scale) < 0 then begin
        var LLayerRect := ALGetShapeSurfaceRect(
                            LRect, // const ARect: TrectF;
                            LCurrentAdjustedStateStyle.Fill.Color, // const AFillColor: TAlphaColor;
                            LCurrentAdjustedStateStyle.Fill.Gradient.Colors, // const AFillGradientColors: TArray<TAlphaColor>;
                            LCurrentAdjustedStateStyle.Fill.ResourceName, // const AFillResourceName: String;
                            LCurrentAdjustedStateStyle.Fill.BackgroundMargins.Rect, // Const AFillBackgroundMarginsRect: TRectF;
                            LCurrentAdjustedStateStyle.Fill.ImageMargins.Rect, // Const AFillImageMarginsRect: TRectF;
                            LCurrentAdjustedStateStyle.StateLayer.Opacity, // const AStateLayerOpacity: Single;
                            LCurrentAdjustedStateStyle.StateLayer.Color, // const AStateLayerColor: TAlphaColor;
                            LCurrentAdjustedStateStyle.StateLayer.UseContentColor, // const AStateLayerUseContentColor: Boolean;
                            LCurrentAdjustedStateStyle.StateLayer.Margins.Rect, // Const AStateLayerMarginsRect: TRectF;
                            LCurrentAdjustedStateStyle.Shadow.Color, // const AShadowColor: TAlphaColor;
                            LCurrentAdjustedStateStyle.Shadow.Blur, // const AShadowBlur: Single;
                            LCurrentAdjustedStateStyle.Shadow.OffsetX, // const AShadowOffsetX: Single;
                            LCurrentAdjustedStateStyle.Shadow.OffsetY); // const AShadowOffsetY: Single);
        ALBeginTransparencyLayer(
          TSkCanvasCustom(Canvas).Canvas.Handle, // const aCanvas: TALCanvas;
          LLayerRect, // const ARect: TRectF;
          AbsoluteOpacity); // const AOpacity: Single);
      end;
      try

        ALDrawRectangle(
          TSkCanvasCustom(Canvas).Canvas.Handle, // const ACanvas: TALCanvas;
          1, // const AScale: Single;
          LRect, // const Rect: TrectF;
          1, // const AOpacity: Single;
          LCurrentAdjustedStateStyle.Fill, // const Fill: TALBrush;
          LCurrentAdjustedStateStyle.StateLayer, // const StateLayer: TALStateLayer;
          LCurrentAdjustedStateStyle.CheckMark.Color, // const AStateLayerContentColor: TAlphaColor;
          False, // const ADrawStateLayerOnTop: Boolean;
          LCurrentAdjustedStateStyle.Stroke, // const Stroke: TALStrokeBrush;
          LCurrentAdjustedStateStyle.Shadow, // const Shadow: TALShadow
          AllSides, // const Sides: TSides;
          AllCorners, // const Corners: TCorners;
          XRadius, // const XRadius: Single = 0;
          YRadius); // const YRadius: Single = 0);

        DrawCheckMark(
          TSkCanvasCustom(Canvas).Canvas.Handle, // const ACanvas: TALCanvas;
          1, // const AScale: Single;
          LRect, // const ADstRect: TrectF;
          // Check CheckMark.Color = TalphaColors.Null to enable an interpolation fade-out effect on the checkMark.
          // Without this, the checkMark disappears immediately.
          Checked or (TBaseStateStyle(StateStyles.GetCurrentRawStyle).CheckMark.Color = TalphaColors.Null), // const AChecked: Boolean
          LCurrentAdjustedStateStyle.CheckMark); // const ACheckMark: TCheckMarkBrush;

      finally
        if compareValue(AbsoluteOpacity, 1, Tepsilon.Scale) < 0 then
          ALEndTransparencyLayer(TSkCanvasCustom(Canvas).Canvas.Handle);
      end;

      {$ELSE}

      if StateStyles.IsTransitionAnimationRunning then begin

        var LRect := LocalRect;
        var LBufSurface: TALSurface;
        var LBufCanvas: TALCanvas;
        var LBufDrawable: TALDrawable;
        StateStyles.GetTransitionBufSurface(
            LRect, // var ARect: TrectF;
            LBufSurface, // out ABufSurface: TALSurface;
            LBufCanvas, // out ABufCanvas: TALCanvas;
            LBufDrawable); // out ABufDrawable: TALDrawable);

        ALClearCanvas(LBufCanvas, TAlphaColors.Null);

        ALDrawRectangle(
          LBufCanvas, // const ACanvas: TALCanvas;
          ALGetScreenScale, // const AScale: Single;
          LRect, // const Rect: TrectF;
          1, // const AOpacity: Single;
          LCurrentAdjustedStateStyle.Fill, // const Fill: TALBrush;
          LCurrentAdjustedStateStyle.StateLayer, // const StateLayer: TALStateLayer;
          LCurrentAdjustedStateStyle.CheckMark.Color, // const AStateLayerContentColor: TAlphaColor;
          False, // const ADrawStateLayerOnTop: Boolean;
          LCurrentAdjustedStateStyle.Stroke, // const Stroke: TALStrokeBrush;
          LCurrentAdjustedStateStyle.Shadow, // const Shadow: TALShadow
          AllSides, // const Sides: TSides;
          AllCorners, // const Corners: TCorners;
          XRadius, // const XRadius: Single = 0;
          YRadius); // const YRadius: Single = 0);

        DrawCheckMark(
          LBufCanvas, // const ACanvas: TALCanvas;
          ALGetScreenScale, // const AScale: Single;
          LRect, // const ADstRect: TrectF;
          // Check CheckMark.Color = TalphaColors.Null to enable an interpolation fade-out effect on the checkMark.
          // Without this, the checkMark disappears immediately.
          Checked or (TBaseStateStyle(StateStyles.GetCurrentRawStyle).CheckMark.Color = TalphaColors.Null), // const AChecked: Boolean
          LCurrentAdjustedStateStyle.CheckMark); // const ACheckMark: TCheckMarkBrush;

        // The Shadow or Statelayer are not included in the dimensions of the LRect rectangle.
        // However, the LRect rectangle is offset by the dimensions of the shadow/Statelayer.
        LRect.Offset(-2*LRect.Left, -2*LRect.Top);

        ALUpdateDrawableFromSurface(LBufSurface, LBufDrawable);
        ALDrawDrawable(
          Canvas, // const ACanvas: Tcanvas;
          LBufDrawable, // const ADrawable: TALDrawable;
          LRect.TopLeft, // const ADstTopLeft: TpointF;
          AbsoluteOpacity); // const AOpacity: Single)

      end

      {$IF defined(DEBUG)}
      else if not doublebuffered then
        raise Exception.Create('Controls that are not double-buffered only work when SKIA is enabled.');
      {$ENDIF}

      {$ENDIF}

    finally
      if LCanvasSaveState <> nil then
        Canvas.RestoreState(LCanvasSaveState);
    end;

    exit;
  end;

  ALDrawDrawable(
    Canvas, // const ACanvas: Tcanvas;
    LDrawable, // const ADrawable: TALDrawable;
    LDrawableRect.TopLeft, // const ATopLeft: TpointF;
    AbsoluteOpacity); // const AOpacity: Single);

end;

{****************************************************}
function TALCheckBox.GetStateStyles: TCheckBoxStateStyles;
begin
  Result := TCheckBoxStateStyles(inherited StateStyles);
end;

{****************************************************}
procedure TALCheckBox.SetStateStyles(const AValue: TCheckBoxStateStyles);
begin
  inherited StateStyles := AValue;
end;

{****************************************************}
function TALCheckBox.CreateStateStyles: TALBaseCheckBox.TStateStyles;
begin
  Result := TCheckBoxStateStyles.Create(Self);
end;

{****************************************************}
constructor TALRadioButton.Create(AOwner: TComponent);

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  procedure _UpdateCheckMark(const aCheckMark: TCheckMarkBrush);
  begin
    var LCheckMarkChanged: TNotifyEvent := ACheckMark.OnChanged;
    ACheckMark.OnChanged := nil;
    ACheckMark.Margins.DefaultValue := TRectF.Create(5,5,5,5);
    ACheckMark.Margins.Rect := CheckMark.Margins.DefaultValue;
    ACheckMark.OnChanged := LCheckMarkChanged;
  end;

begin
  inherited;
  FGroupName := '';
  fMandatory := false;
  FXRadius := -50;
  FYRadius := -50;
  _UpdateCheckMark(CheckMark);
  _UpdateCheckMark(StateStyles.Checked.Default.CheckMark);
  _UpdateCheckMark(StateStyles.Checked.Disabled.CheckMark);
  _UpdateCheckMark(StateStyles.Checked.Hovered.CheckMark);
  _UpdateCheckMark(StateStyles.Checked.Pressed.CheckMark);
  _UpdateCheckMark(StateStyles.Checked.Focused.CheckMark);
  _UpdateCheckMark(StateStyles.UnChecked.Default.CheckMark);
  _UpdateCheckMark(StateStyles.UnChecked.Disabled.CheckMark);
  _UpdateCheckMark(StateStyles.UnChecked.Hovered.CheckMark);
  _UpdateCheckMark(StateStyles.UnChecked.Pressed.CheckMark);
  _UpdateCheckMark(StateStyles.UnChecked.Focused.CheckMark);
  TMessageManager.DefaultManager.SubscribeToMessage(TRadioButtonGroupMessage, GroupMessageCall);
end;

{********************************}
destructor TALRadioButton.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TRadioButtonGroupMessage, GroupMessageCall);
  inherited;
end;

{********************************************************}
procedure TALRadioButton.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then begin
    if (csDesigning in ComponentState) and FChecked then inherited SetChecked(Value) // allows check/uncheck in design-mode
    else begin
      if (not value) and fMandatory then exit;
      inherited SetChecked(Value);
      if Value then begin
        var M := TRadioButtonGroupMessage.Create(GroupName);
        TMessageManager.DefaultManager.SendMessage(Self, M, True);
      end;
    end;
  end;
end;

{******************************************}
function TALRadioButton.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(20, 20);
end;

{*******************************************}
function TALRadioButton.GetGroupName: string;
begin
  Result := FGroupName;
end;

{**********************************************************************************}
procedure TALRadioButton.GroupMessageCall(const Sender: TObject; const M: TMessage);
begin
  if SameText(TRadioButtonGroupMessage(M).GroupName, GroupName) and (Sender <> Self) and (Scene <> nil) and
     (not (Sender is TControl) or ((Sender as TControl).Scene = Scene)) then begin
    var LOldMandatory := fMandatory;
    fMandatory := False;
    try
      Checked := False;
    finally
      fMandatory := LOldMandatory;
    end;
  end;
end;

{***********************************************}
function TALRadioButton.GroupNameStored: Boolean;
begin
  Result := FGroupName <> '';
end;

{*********************************************************}
procedure TALRadioButton.SetGroupName(const Value: string);
begin
  if FGroupName <> Value then
    FGroupName := Value;
end;

{*************************}
procedure TALRadioButton.DrawCheckMark(
            const ACanvas: TALCanvas;
            const AScale: Single;
            const ADstRect: TrectF;
            const AChecked: Boolean;
            const ACheckMark: TALBaseCheckBox.TCheckMarkBrush);
begin

  var LRect := ADstRect;
  LRect.Top := LRect.Top * AScale;
  LRect.right := LRect.right * AScale;
  LRect.left := LRect.left * AScale;
  LRect.bottom := LRect.bottom * AScale;
  var LScaledMarginsRect := ACheckMark.Margins.Rect;
  LScaledMarginsRect.Left := LScaledMarginsRect.Left * AScale;
  LScaledMarginsRect.right := LScaledMarginsRect.right * AScale;
  LScaledMarginsRect.top := LScaledMarginsRect.top * AScale;
  LScaledMarginsRect.bottom := LScaledMarginsRect.bottom * AScale;
  LRect.Top := LRect.Top + LScaledMarginsRect.top;
  LRect.right := LRect.right - LScaledMarginsRect.right;
  LRect.left := LRect.left + LScaledMarginsRect.left;
  LRect.bottom := LRect.bottom - LScaledMarginsRect.bottom;
  if LRect.IsEmpty then exit;

  // Without ResourceName
  if ACheckMark.ResourceName = '' then begin

    // exit if not checked
    if not AChecked then
      exit;

    ALDrawCircle(
      ACanvas, // const ACanvas: TALCanvas;
      1, // const AScale: Single;
      LRect, // const ADstRect: TrectF;
      1, // const AOpacity: Single;
      ACheckMark.Color, // const AFillColor: TAlphaColor;
      TGradientStyle.Linear, // const AFillGradientStyle: TGradientStyle;
      [], // const AFillGradientColors: TArray<TAlphaColor>;
      [], // const AFillGradientOffsets: TArray<Single>;
      TPointF.Zero, // const AFillGradientStartPoint: TPointF; // Coordinates in ADstRect space. You can use ALGetLinearGradientCoordinates to convert angle to point
      TPointF.Zero, // const AFillGradientEndPoint: TPointF; // Coordinates in ADstRect space. You can use ALGetLinearGradientCoordinates to convert angle to point
      ACheckMark.ResourceName, // const AFillResourceName: String;
      ACheckMark.WrapMode, // Const AFillWrapMode: TALImageWrapMode;
      TRectF.Empty, // Const AFillBackgroundMarginsRect: TRectF;
      TRectF.Empty, // Const AFillImageMarginsRect: TRectF;
      0, // const AStateLayerOpacity: Single;
      TAlphaColors.Null, // const AStateLayerColor: TAlphaColor;
      TRectF.Empty, // Const AStateLayerMarginsRect: TRectF;
      0, // const AStateLayerXRadius: Single;
      0, // const AStateLayerYRadius: Single;
      False, // const ADrawStateLayerOnTop: Boolean;
      TAlphaColors.Null, // const AStrokeColor: TalphaColor;
      0, // const AStrokeThickness: Single;
      TAlphaColors.Null, // const AShadowColor: TAlphaColor; // If ShadowColor is not null, the Canvas should have adequate space to accommodate the shadow. You can use the ALGetShadowWidth function to estimate the required width.
      0, // const AShadowBlur: Single;
      0, // const AShadowOffsetX: Single;
      0); // const AShadowOffsetY: Single;

  end

  // With ResourceName
  else begin

    ALDrawRectangle(
      ACanvas, // const ACanvas: TALCanvas;
      1, // const AScale: Single;
      LRect, // const ADstRect: TrectF;
      1, // const AOpacity: Single;
      ACheckMark.Color, // const AFillColor: TAlphaColor;
      TGradientStyle.Linear, // const AFillGradientStyle: TGradientStyle;
      [], // const AFillGradientColors: TArray<TAlphaColor>;
      [], // const AFillGradientOffsets: TArray<Single>;
      TPointF.Zero, // const AFillGradientStartPoint: TPointF; // Coordinates in ADstRect space. You can use ALGetLinearGradientCoordinates to convert angle to point
      TPointF.Zero, // const AFillGradientEndPoint: TPointF; // Coordinates in ADstRect space. You can use ALGetLinearGradientCoordinates to convert angle to point
      ACheckMark.ResourceName, // const AFillResourceName: String;
      ACheckMark.WrapMode, // Const AFillWrapMode: TALImageWrapMode;
      TRectF.Empty, // Const AFillBackgroundMarginsRect: TRectF;
      TRectF.Empty, // Const AFillImageMarginsRect: TRectF;
      0, // const AStateLayerOpacity: Single;
      TAlphaColors.Null, // const AStateLayerColor: TAlphaColor;
      TRectF.Empty, // Const AStateLayerMarginsRect: TRectF;
      0, // const AStateLayerXRadius: Single;
      0, // const AStateLayerYRadius: Single;
      False, // const ADrawStateLayerOnTop: Boolean;
      TAlphaColors.Null, // const AStrokeColor: TalphaColor;
      0, // const AStrokeThickness: Single;
      TAlphaColors.Null, // const AShadowColor: TAlphaColor; // If ShadowColor is not null, the Canvas should have adequate space to accommodate the shadow. You can use the ALGetShadowWidth function to estimate the required width.
      0, // const AShadowBlur: Single;
      0, // const AShadowOffsetX: Single;
      0, // const AShadowOffsetY: Single;
      AllSides, // const ASides: TSides;
      AllCorners, // const ACorners: TCorners;
      0, // const AXRadius: Single;
      0); // const AYRadius: Single)

  end;

end;

{***********************************}
constructor TALSwitch.TTrack.TBaseStateStyle.Create(const AParent: TObject);
begin
  inherited Create(AParent);
  //--
  StateLayer.DefaultXRadius := -50;
  StateLayer.DefaultYRadius := -50;
  StateLayer.XRadius := StateLayer.DefaultXRadius;
  StateLayer.YRadius := StateLayer.DefaultYRadius;
end;

{**********************************************************}
function TALSwitch.TTrack.TDisabledStateStyle.IsOpacityStored: Boolean;
begin
  Result := not SameValue(FOpacity, TControl.DefaultDisabledOpacity, TEpsilon.Scale);
end;

{********************************************************************}
procedure TALSwitch.TTrack.TDisabledStateStyle.SetOpacity(const Value: Single);
begin
  if not SameValue(FOpacity, Value, TEpsilon.Scale) then begin
    FOpacity := Value;
    Change;
  end;
end;

{***********************************************************************}
constructor TALSwitch.TTrack.TDisabledStateStyle.Create(const AParent: TObject);
begin
  inherited Create(AParent);
  FOpacity := TControl.DefaultDisabledOpacity;
end;

{****************************************************************}
procedure TALSwitch.TTrack.TDisabledStateStyle.Assign(Source: TPersistent);
begin
  BeginUpdate;
  Try
    if Source is TDisabledStateStyle then
      Opacity := TDisabledStateStyle(Source).Opacity
    else
      Opacity := TControl.DefaultDisabledOpacity;
    inherited Assign(Source);
  Finally
    EndUpdate;
  End;
end;

{******************************}
procedure TALSwitch.TTrack.TDisabledStateStyle.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Opacity := TControl.DefaultDisabledOpacity;
  finally
    EndUpdate;
  end;
end;

{******************************}
function TALSwitch.TTrack.TDisabledStateStyle.GetInherit: Boolean;
begin
  // Opacity is not part of the GetInherit function because it updates the
  // disabledOpacity of the base control immediately every time it changes.
  // Essentially, it acts merely as a link to the disabledOpacity of the base control.
  Result := inherited GetInherit;
end;

{*************************************}
constructor TALSwitch.TTrack.TCheckStateStyles.Create(const AParent: TALSwitch.TTrack);
begin
  inherited Create;
  //--
  FDefault := TDefaultStateStyle.Create(AParent);
  FDefault.OnChanged := DefaultChanged;
  //--
  FDisabled := TDisabledStateStyle.Create(FDefault);
  FDisabled.OnChanged := DisabledChanged;
  //--
  FHovered := THoveredStateStyle.Create(FDefault);
  FHovered.OnChanged := HoveredChanged;
  //--
  FPressed := TPressedStateStyle.Create(FDefault);
  FPressed.OnChanged := PressedChanged;
  //--
  FFocused := TFocusedStateStyle.Create(FDefault);
  FFocused.OnChanged := FocusedChanged;
end;

{*************************************}
destructor TALSwitch.TTrack.TCheckStateStyles.Destroy;
begin
  ALFreeAndNil(FDefault);
  ALFreeAndNil(FDisabled);
  ALFreeAndNil(FHovered);
  ALFreeAndNil(FPressed);
  ALFreeAndNil(FFocused);
  inherited Destroy;
end;

{*********************************}
function TALSwitch.TTrack.TCheckStateStyles.CreateSavedState: TALPersistentObserver;
type
  TCheckStateStylesClass = class of TCheckStateStyles;
begin
  result := TCheckStateStylesClass(classtype).Create(nil{AParent});
end;

{******************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.Assign(Source: TPersistent);
begin
  if Source is TCheckStateStyles then begin
    BeginUpdate;
    Try
      Default.Assign(TCheckStateStyles(Source).Default);
      Disabled.Assign(TCheckStateStyles(Source).Disabled);
      Hovered.Assign(TCheckStateStyles(Source).Hovered);
      Pressed.Assign(TCheckStateStyles(Source).Pressed);
      Focused.Assign(TCheckStateStyles(Source).Focused);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{******************************}
procedure TALSwitch.TTrack.TCheckStateStyles.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Default.Reset;
    Disabled.Reset;
    Hovered.Reset;
    Pressed.Reset;
    Focused.Reset;
  finally
    EndUpdate;
  end;
end;

{******************************}
procedure TALSwitch.TTrack.TCheckStateStyles.ClearBufDrawable;
begin
  Default.ClearBufDrawable;
  Disabled.ClearBufDrawable;
  Hovered.ClearBufDrawable;
  Pressed.ClearBufDrawable;
  Focused.ClearBufDrawable;
end;

{************************************************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.SetDefault(const AValue: TDefaultStateStyle);
begin
  FDefault.Assign(AValue);
end;

{************************************************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.SetDisabled(const AValue: TDisabledStateStyle);
begin
  FDisabled.Assign(AValue);
end;

{************************************************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.SetHovered(const AValue: THoveredStateStyle);
begin
  FHovered.Assign(AValue);
end;

{*******************************************************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.SetPressed(const AValue: TPressedStateStyle);
begin
  FPressed.Assign(AValue);
end;

{*******************************************************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.SetFocused(const AValue: TFocusedStateStyle);
begin
  FFocused.Assign(AValue);
end;

{**********************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.DefaultChanged(ASender: TObject);
begin
  Change;
end;

{**********************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.DisabledChanged(ASender: TObject);
begin
  Change;
end;

{************************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.HoveredChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.PressedChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
procedure TALSwitch.TTrack.TCheckStateStyles.FocusedChanged(ASender: TObject);
begin
  Change;
end;

{*************************************}
constructor TALSwitch.TTrack.TStateStyles.Create(const AParent: TALSwitch.TTrack);
begin
  inherited Create(AParent);
  //--
  FChecked := TCheckStateStyles.Create(AParent);
  FChecked.OnChanged := CheckedChanged;
  //--
  FUnchecked := TCheckStateStyles.Create(AParent);
  FUnchecked.OnChanged := UncheckedChanged;
end;

{*************************************}
destructor TALSwitch.TTrack.TStateStyles.Destroy;
begin
  ALFreeAndNil(FChecked);
  ALFreeAndNil(FUnchecked);
  inherited Destroy;
end;

{*********************************}
function TALSwitch.TTrack.TStateStyles.CreateSavedState: TALPersistentObserver;
type
  TStateStylesClass = class of TStateStyles;
begin
  result := TStateStylesClass(classtype).Create(nil{AParent});
end;

{******************************************************}
procedure TALSwitch.TTrack.TStateStyles.Assign(Source: TPersistent);
begin
  if Source is TStateStyles then begin
    BeginUpdate;
    Try
      Checked.Assign(TStateStyles(Source).Checked);
      Unchecked.Assign(TStateStyles(Source).Unchecked);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{******************************}
procedure TALSwitch.TTrack.TStateStyles.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Checked.reset;
    Unchecked.reset;
  finally
    EndUpdate;
  end;
end;

{******************************}
procedure TALSwitch.TTrack.TStateStyles.ClearBufDrawable;
begin
  inherited;
  Checked.ClearBufDrawable;
  Unchecked.ClearBufDrawable;
end;

{*******************************************************}
function TALSwitch.TTrack.TStateStyles.GetCurrentRawStyle: TALBaseStateStyle;
begin
  if Parent.Checked then begin
    if Not Parent.Enabled then Result := Checked.Disabled
    else if Parent.Pressed then Result := Checked.Pressed
    else if Parent.IsFocused then Result := Checked.Focused
    else if Parent.IsMouseOver then Result := Checked.Hovered
    else result := Checked.Default;
  end
  else begin
    if Not Parent.Enabled then Result := UnChecked.Disabled
    else if Parent.Pressed then Result := UnChecked.Pressed
    else if Parent.IsFocused then Result := UnChecked.Focused
    else if Parent.IsMouseOver then Result := UnChecked.Hovered
    else result := UnChecked.Default;
  end;
end;

{************************************************************************************}
function TALSwitch.TTrack.TStateStyles.GetParent: TALSwitch.TTrack;
begin
  Result := TALSwitch.TTrack(inherited Parent);
end;

{************************************************************************************}
procedure TALSwitch.TTrack.TStateStyles.SetChecked(const AValue: TCheckStateStyles);
begin
  FChecked.Assign(AValue);
end;

{*********************************************************************************}
procedure TALSwitch.TTrack.TStateStyles.SetUnchecked(const AValue: TCheckStateStyles);
begin
  FUnchecked.Assign(AValue);
end;

{**********************************************************}
procedure TALSwitch.TTrack.TStateStyles.CheckedChanged(ASender: TObject);
begin
  Change;
end;

{**********************************************************}
procedure TALSwitch.TTrack.TStateStyles.UncheckedChanged(ASender: TObject);
begin
  Change;
end;

{*************************************************}
constructor TALSwitch.TTrack.Create(AOwner: TComponent);
begin
  inherited;
  //--
  SetAcceptsControls(False);
  CanFocus := False;
  Locked := True;
  HitTest := False;
  //--
  var LFillChanged: TNotifyEvent := fill.OnChanged;
  fill.OnChanged := nil;
  Fill.DefaultColor := $ffc5c5c5;
  Fill.Color := Fill.DefaultColor;
  fill.OnChanged := LFillChanged;
  //--
  var LStrokeChanged: TNotifyEvent := stroke.OnChanged;
  stroke.OnChanged := Nil;
  Stroke.DefaultColor := TAlphaColors.null;
  Stroke.Color := Stroke.DefaultColor;
  stroke.OnChanged := LStrokeChanged;
  //--
  FChecked := False;
  FDoubleBuffered := true;
  FDefaultXRadius := -50;
  FDefaultYRadius := -50;
  FXRadius := FDefaultXRadius;
  FYRadius := FDefaultYRadius;
  //--
  // Must be created at the end because it requires FCheckMark to
  // be already created.
  FStateStyles := TStateStyles.Create(self);
  FStateStyles.OnChanged := StateStylesChanged;
end;

{*****************************}
destructor TALSwitch.TTrack.Destroy;
begin
  ALFreeAndNil(FStateStyles);
  inherited;
end;

{***********************************************}
function TALSwitch.TTrack.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(52, 32);
end;

{***********************************************}
function TALSwitch.TTrack.GetDoubleBuffered: boolean;
begin
  result := fDoubleBuffered;
end;

{**************************************************************}
procedure TALSwitch.TTrack.SetDoubleBuffered(const AValue: Boolean);
begin
  if AValue <> fDoubleBuffered then begin
    fDoubleBuffered := AValue;
    if not fDoubleBuffered then clearBufDrawable;
  end;
end;

{***************************************}
function TALSwitch.TTrack.GetChecked: Boolean;
begin
  Result := FChecked;
end;

{*****************************************************}
procedure TALSwitch.TTrack.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then begin
    FChecked := Value;
    if FChecked then DisabledOpacity := StateStyles.Checked.Disabled.opacity
    else DisabledOpacity := StateStyles.Unchecked.Disabled.opacity;
    DoChanged;
  end;
end;

{*********************************************************************}
procedure TALSwitch.TTrack.SetStateStyles(const AValue: TStateStyles);
begin
  FStateStyles.Assign(AValue);
end;

{**************************************************}
function TALSwitch.TTrack.IsXRadiusStored: Boolean;
begin
  Result := not SameValue(FXRadius, FDefaultXRadius, TEpsilon.Vector);
end;

{**************************************************}
function TALSwitch.TTrack.IsYRadiusStored: Boolean;
begin
  Result := not SameValue(FYRadius, FDefaultYRadius, TEpsilon.Vector);
end;

{****************************************************}
procedure TALSwitch.TTrack.SetXRadius(const Value: Single);
var
  NewValue: Single;
begin
  if csDesigning in ComponentState then NewValue := Max(-50, Min(Value, Min(Width / 2, Height / 2)))
  else NewValue := Value;
  if not SameValue(FXRadius, NewValue, TEpsilon.Vector) then begin
    clearBufDrawable;
    FXRadius := NewValue;
    Repaint;
  end;
end;

{****************************************************}
procedure TALSwitch.TTrack.SetYRadius(const Value: Single);
var
  NewValue: Single;
begin
  if csDesigning in ComponentState then NewValue := Max(-50, Min(Value, Min(Width / 2, Height / 2)))
  else NewValue := Value;
  if not SameValue(FYRadius, NewValue, TEpsilon.Vector) then begin
    clearBufDrawable;
    FYRadius := NewValue;
    Repaint;
  end;
end;

{**************************************************}
procedure TALSwitch.TTrack.FillChanged(Sender: TObject);
begin
  clearBufDrawable;
  inherited;
end;

{****************************************************}
procedure TALSwitch.TTrack.StrokeChanged(Sender: TObject);
begin
  clearBufDrawable;
  inherited;
end;

{****************************************************}
procedure TALSwitch.TTrack.ShadowChanged(Sender: TObject);
begin
  clearBufDrawable;
  inherited;
end;

{******************************************************}
procedure TALSwitch.TTrack.StateStylesChanged(Sender: TObject);
begin
  clearBufDrawable;
  if Checked then DisabledOpacity := StateStyles.Checked.Disabled.opacity
  else DisabledOpacity := StateStyles.Unchecked.Disabled.opacity;
  Repaint;
end;

{**************************************************}
procedure TALSwitch.TTrack.IsMouseOverChanged;
begin
  inherited;
  StateStyles.startTransition;
  repaint;
end;

{********************************************}
procedure TALSwitch.TTrack.IsFocusedChanged;
begin
  inherited;
  StateStyles.startTransition;
  repaint;
end;

{**************************************************}
procedure TALSwitch.TTrack.PressedChanged;
begin
  inherited;
  StateStyles.startTransition;
  repaint;
end;

{******************************}
procedure TALSwitch.TTrack.DoChanged;
begin
  Repaint;
end;

{******************************}
procedure TALSwitch.TTrack.DoResized;
begin
  ClearBufDrawable;
  inherited;
end;

{***********************************}
procedure TALSwitch.TTrack.clearBufDrawable;
begin
  {$IFDEF debug}
  if (FStateStyles <> nil) and
     (not (csDestroying in ComponentState)) and
     ((not ALIsDrawableNull(FStateStyles.Checked.Default.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Checked.Disabled.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Checked.Hovered.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Checked.Pressed.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Checked.Focused.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Default.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Disabled.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Hovered.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Pressed.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.UnChecked.Focused.BufDrawable))) then
    ALLog(Classname + '.clearBufDrawable', 'BufDrawable has been cleared | Name: ' + Name, TalLogType.warn);
  {$endif}
  if FStateStyles <> nil then
    FStateStyles.ClearBufDrawable;
end;

{************************************}
procedure TALSwitch.TTrack.MakeBufDrawable;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  function _DoMakeBufDrawable(const AStateStyle: TBaseStateStyle): boolean;
  begin
    if (not ALIsDrawableNull(AStateStyle.BufDrawable)) then exit(False);
    AStateStyle.SupersedeNoChanges(true{ASaveState});
    try
      CreateBufDrawable(
        AStateStyle.BufDrawable, // var ABufDrawable: TALDrawable;
        AStateStyle.BufDrawableRect, // var ABufDrawableRect: TRectF;
        AStateStyle.Fill, // const AFill: TALBrush;
        AStateStyle.StateLayer, // const AStateLayer: TALStateLayer;
        AStateStyle.Stroke, // const AStroke: TALStrokeBrush;
        AStateStyle.Shadow); // const AShadow: TALShadow);
    finally
      AStateStyle.RestorestateNoChanges;
    end;
    Result := True;
  end;

begin
  //--- Do not create BufDrawable if we are in the middle of a transition
  if StateStyles.IsTransitionAnimationRunning then
    exit;
  //--- Do not create BufDrawable if not DoubleBuffered
  if {$IF not DEFINED(ALDPK)}(not DoubleBuffered){$ELSE}False{$ENDIF} then begin
    clearBufDrawable;
    exit;
  end;
  //--
  if Checked then _DoMakeBufDrawable(StateStyles.Checked.Default)
  else _DoMakeBufDrawable(StateStyles.UnChecked.Default);
  //--
  var LStateStyle := TBaseStateStyle(StateStyles.GetCurrentRawStyle);
  if LStateStyle = nil then exit;
  if LStateStyle.Inherit then exit;
  _DoMakeBufDrawable(LStateStyle);
  // No need to center LStateStyle.BufDrawableRect on the main BufDrawableRect
  // because BufDrawableRect always has the width and height of the localRect.
end;

{**************************************}
Procedure TALSwitch.TTrack.CreateBufDrawable(
            var ABufDrawable: TALDrawable;
            out ABufDrawableRect: TRectF;
            const AFill: TALBrush;
            const AStateLayer: TALStateLayer;
            const AStroke: TALStrokeBrush;
            const AShadow: TALShadow);
begin

  if (not ALIsDrawableNull(ABufDrawable)) then exit;

  ABufDrawableRect := LocalRect;
  var LSurfaceRect := ALGetShapeSurfaceRect(
                        ABufDrawableRect, // const ARect: TRectF;
                        AFill, // const AFill: TALBrush;
                        AStateLayer, // const AStateLayer: TALStateLayer;
                        AShadow); // const AShadow: TALShadow): TRectF;
  LSurfaceRect := ALAlignDimensionToPixelCeil(LSurfaceRect, ALGetScreenScale, TEpsilon.Position); // To obtain a drawable with pixel-aligned width and height
  ABufDrawableRect.Offset(-LSurfaceRect.Left, -LSurfaceRect.Top);

  var LSurface: TALSurface;
  var LCanvas: TALCanvas;
  ALCreateSurface(
    LSurface, // out ASurface: TALSurface;
    LCanvas, // out ACanvas: TALCanvas;
    ALGetScreenScale, // const AScale: Single;
    LSurfaceRect.Width, // const w: integer;
    LSurfaceRect.height);// const h: integer)
  try

    if ALCanvasBeginScene(LCanvas) then
    try

      ALDrawRectangle(
        LCanvas, // const ACanvas: TALCanvas;
        ALGetScreenScale, // const AScale: Single;
        ABufDrawableRect, // const Rect: TrectF;
        1, // const AOpacity: Single;
        AFill, // const Fill: TALBrush;
        AStateLayer, // const StateLayer: TALStateLayer;
        TAlphaColors.Null, // const AStateLayerContentColor: TAlphaColor;
        False, // const ADrawStateLayerOnTop: Boolean;
        AStroke, // const Stroke: TALStrokeBrush;
        AShadow, // const Shadow: TALShadow
        AllSides, // const Sides: TSides;
        AllCorners, // const Corners: TCorners;
        XRadius, // const XRadius: Single = 0;
        YRadius); // const YRadius: Single = 0);

    finally
      ALCanvasEndScene(LCanvas)
    end;

    ABufDrawable := ALCreateDrawableFromSurface(LSurface);
    // The Shadow or Statelayer are not included in the dimensions of the fBufDrawableRect rectangle.
    // However, the fBufDrawableRect rectangle is offset by the dimensions of the shadow/Statelayer.
    ABufDrawableRect.Offset(-2*ABufDrawableRect.Left, -2*ABufDrawableRect.Top);

  finally
    ALFreeAndNilSurface(LSurface, LCanvas);
  end;

end;

{**************************}
procedure TALSwitch.TTrack.Paint;
begin

  StateStyles.UpdateLastPaintedRawStyle;
  MakeBufDrawable;

  var LDrawable: TALDrawable;
  var LDrawableRect: TRectF;
  if StateStyles.IsTransitionAnimationRunning then begin
    LDrawable := ALNullDrawable;
    LDrawableRect := TRectF.Empty;
  end
  else begin
    var LStateStyle := TBaseStateStyle(StateStyles.GetCurrentRawStyle);
    if LStateStyle <> nil then begin
      LDrawable := LStateStyle.BufDrawable;
      LDrawableRect := LStateStyle.BufDrawableRect;
      if ALIsDrawableNull(LDrawable) then begin
        if checked then begin
          LDrawable := StateStyles.Checked.default.BufDrawable;
          LDrawableRect := StateStyles.Checked.default.BufDrawableRect;
        end
        else begin
          LDrawable := StateStyles.UnChecked.default.BufDrawable;
          LDrawableRect := StateStyles.UnChecked.default.BufDrawableRect;
        end;
      end;
    end
    else
      raise Exception.Create('Error #EA9B4064-F1D2-4E04-82FE-99FD3ED8B1F3');
  end;

  if ALIsDrawableNull(LDrawable) then begin

    var LCurrentAdjustedStateStyle := TBaseStateStyle(StateStyles.GetCurrentAdjustedStyle);
    if LCurrentAdjustedStateStyle = nil then begin
      inherited Paint;
      exit;
    end;

    var LCanvasSaveState: TCanvasSaveState := ALScaleAndCenterCanvas(
                                                Canvas, // Const ACanvas: TCanvas;
                                                AbsoluteRect, // Const AAbsoluteRect: TRectF;
                                                LCurrentAdjustedStateStyle.Scale.x, // Const AScaleX: Single;
                                                LCurrentAdjustedStateStyle.Scale.y, // Const AScaleY: Single;
                                                true); // Const ASaveState: Boolean);
    try

      {$IF DEFINED(ALSkiaCanvas)}

      // Canvas.AlignToPixel is used because when we call ALDrawDrawable,
      // we do LDstRect := ACanvas.AlignToPixel(LDstRect).
      // Therefore, when drawing directly on the canvas,
      // we must draw at the exact same position as when we call ALDrawDrawable.
      var LRect := Canvas.AlignToPixel(LocalRect);

      if compareValue(AbsoluteOpacity, 1, Tepsilon.Scale) < 0 then begin
        var LLayerRect := ALGetShapeSurfaceRect(
                            LRect, // const ARect: TrectF;
                            LCurrentAdjustedStateStyle.Fill.Color, // const AFillColor: TAlphaColor;
                            LCurrentAdjustedStateStyle.Fill.Gradient.Colors, // const AFillGradientColors: TArray<TAlphaColor>;
                            LCurrentAdjustedStateStyle.Fill.ResourceName, // const AFillResourceName: String;
                            LCurrentAdjustedStateStyle.Fill.BackgroundMargins.Rect, // Const AFillBackgroundMarginsRect: TRectF;
                            LCurrentAdjustedStateStyle.Fill.ImageMargins.Rect, // Const AFillImageMarginsRect: TRectF;
                            LCurrentAdjustedStateStyle.StateLayer.Opacity, // const AStateLayerOpacity: Single;
                            LCurrentAdjustedStateStyle.StateLayer.Color, // const AStateLayerColor: TAlphaColor;
                            LCurrentAdjustedStateStyle.StateLayer.UseContentColor, // const AStateLayerUseContentColor: Boolean;
                            LCurrentAdjustedStateStyle.StateLayer.Margins.Rect, // Const AStateLayerMarginsRect: TRectF;
                            LCurrentAdjustedStateStyle.Shadow.Color, // const AShadowColor: TAlphaColor;
                            LCurrentAdjustedStateStyle.Shadow.Blur, // const AShadowBlur: Single;
                            LCurrentAdjustedStateStyle.Shadow.OffsetX, // const AShadowOffsetX: Single;
                            LCurrentAdjustedStateStyle.Shadow.OffsetY); // const AShadowOffsetY: Single);
        ALBeginTransparencyLayer(
          TSkCanvasCustom(Canvas).Canvas.Handle, // const aCanvas: TALCanvas;
          LLayerRect, // const ARect: TRectF;
          AbsoluteOpacity); // const AOpacity: Single);
      end;
      try

        ALDrawRectangle(
          TSkCanvasCustom(Canvas).Canvas.Handle, // const ACanvas: TALCanvas;
          1, // const AScale: Single;
          LRect, // const Rect: TrectF;
          1, // const AOpacity: Single;
          LCurrentAdjustedStateStyle.Fill, // const Fill: TALBrush;
          LCurrentAdjustedStateStyle.StateLayer, // const StateLayer: TALStateLayer;
          TAlphaColors.Null, // const AStateLayerContentColor: TAlphaColor;
          False, // const ADrawStateLayerOnTop: Boolean;
          LCurrentAdjustedStateStyle.Stroke, // const Stroke: TALStrokeBrush;
          LCurrentAdjustedStateStyle.Shadow, // const Shadow: TALShadow
          AllSides, // const Sides: TSides;
          AllCorners, // const Corners: TCorners;
          XRadius, // const XRadius: Single = 0;
          YRadius); // const YRadius: Single = 0);

      finally
        if compareValue(AbsoluteOpacity, 1, Tepsilon.Scale) < 0 then
          ALEndTransparencyLayer(TSkCanvasCustom(Canvas).Canvas.Handle);
      end;

      {$ELSE}

      if StateStyles.IsTransitionAnimationRunning then begin

        var LRect := LocalRect;
        var LBufSurface: TALSurface;
        var LBufCanvas: TALCanvas;
        var LBufDrawable: TALDrawable;
        StateStyles.GetTransitionBufSurface(
            LRect, // var ARect: TrectF;
            LBufSurface, // out ABufSurface: TALSurface;
            LBufCanvas, // out ABufCanvas: TALCanvas;
            LBufDrawable); // out ABufDrawable: TALDrawable);

        ALClearCanvas(LBufCanvas, TAlphaColors.Null);

        ALDrawRectangle(
          LBufCanvas, // const ACanvas: TALCanvas;
          ALGetScreenScale, // const AScale: Single;
          LRect, // const Rect: TrectF;
          1, // const AOpacity: Single;
          LCurrentAdjustedStateStyle.Fill, // const Fill: TALBrush;
          LCurrentAdjustedStateStyle.StateLayer, // const StateLayer: TALStateLayer;
          TAlphaColors.Null, // const AStateLayerContentColor: TAlphaColor;
          False, // const ADrawStateLayerOnTop: Boolean;
          LCurrentAdjustedStateStyle.Stroke, // const Stroke: TALStrokeBrush;
          LCurrentAdjustedStateStyle.Shadow, // const Shadow: TALShadow
          AllSides, // const Sides: TSides;
          AllCorners, // const Corners: TCorners;
          XRadius, // const XRadius: Single = 0;
          YRadius); // const YRadius: Single = 0);

        // The Shadow or Statelayer are not included in the dimensions of the LRect rectangle.
        // However, the LRect rectangle is offset by the dimensions of the shadow/Statelayer.
        LRect.Offset(-2*LRect.Left, -2*LRect.Top);

        ALUpdateDrawableFromSurface(LBufSurface, LBufDrawable);
        ALDrawDrawable(
          Canvas, // const ACanvas: Tcanvas;
          LBufDrawable, // const ADrawable: TALDrawable;
          LRect.TopLeft, // const ADstTopLeft: TpointF;
          AbsoluteOpacity); // const AOpacity: Single)

      end

      {$IF defined(DEBUG)}
      else if not doublebuffered then
        raise Exception.Create('Controls that are not double-buffered only work when SKIA is enabled.');
      {$ENDIF}

      {$ENDIF}

    finally
      if LCanvasSaveState <> nil then
        Canvas.RestoreState(LCanvasSaveState);
    end;

    exit;
  end;

  ALDrawDrawable(
    Canvas, // const ACanvas: Tcanvas;
    LDrawable, // const ADrawable: TALDrawable;
    LDrawableRect.TopLeft, // const ATopLeft: TpointF;
    AbsoluteOpacity); // const AOpacity: Single);

end;

{*************************************************}
procedure TALSwitch.TThumb.TThumbStateStyles.StartTransition;
begin
  FStartPositionX := Parent{Thumb}.Position.x;
  inherited;
  if not IsTransitionAnimationRunning then
    TALSwitch(Parent{Thumb}.ParentControl{Track}.ParentControl{Switch}).AlignThumb;
end;

{*************************************************}
procedure TALSwitch.TThumb.TThumbStateStyles.TransitionAnimationProcess(Sender: TObject);
begin
  var LThumb := Parent;
  var LSwitch := TALSwitch(LThumb.ParentControl{Track}.ParentControl{Switch});
  if (not LSwitch.Pressed) and (Lthumb.Align = TAlignLayout.None) then begin
    var LFloatAnimation := TALFloatAnimation(Sender);
    var LStopPositionX: Single;
    If LSwitch.Checked then LStopPositionX := LSwitch.GetMaxThumbPos
    else LStopPositionX := LSwitch.GetMinThumbPos;
    LThumb.Position.x := FStartPositionX + (LStopPositionX - FStartPositionX) * LFloatAnimation.CurrentValue;
  end;
  inherited;
end;

{*************************************************}
procedure TALSwitch.TThumb.TThumbStateStyles.TransitionAnimationFinish(Sender: TObject);
begin
  TALSwitch(Parent{Thumb}.ParentControl{Track}.ParentControl{Switch}).AlignThumb;
  inherited;
end;

{*************************************************}
constructor TALSwitch.TThumb.Create(AOwner: TComponent);
begin
  inherited;
  //--
  SetAcceptsControls(False);
  CanFocus := False;
  Locked := True;
  HitTest := False;
  //--
  FDefaultXRadius := -50;
  FDefaultYRadius := -50;
  FXRadius := FDefaultXRadius;
  FYRadius := FDefaultYRadius;
  //--
  var LStrokeChanged: TNotifyEvent := stroke.OnChanged;
  stroke.OnChanged := Nil;
  Stroke.DefaultColor := TAlphaColors.null;
  Stroke.Color := Stroke.DefaultColor;
  stroke.OnChanged := LStrokeChanged;
  //--
  var LCheckMarkChanged: TNotifyEvent := CheckMark.OnChanged;
  CheckMark.OnChanged := Nil;
  CheckMark.Margins.DefaultValue := TRectF.Create(6,6,6,6);
  CheckMark.Margins.Rect := CheckMark.Margins.DefaultValue;
  CheckMark.OnChanged := LCheckMarkChanged;
  //--
  Margins.DefaultValue := TRectF.Create(4,4,4,4);
  Margins.Rect := Margins.DefaultValue;
end;

{***********************************************}
function TALSwitch.TThumb.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(24, 24);
end;

{***********************************************}
function TALSwitch.TThumb.CreateStateStyles: TALBaseCheckBox.TStateStyles;
begin
  result := TThumbStateStyles.Create(Self);
end;

{***********************************************}
procedure TALSwitch.TThumb.Click;
begin
  // Since TALSwitch.TThumb has HitTest set to false, this event
  // is triggered only at the end of the transition animation when
  // DelayClick is set to true.
  TALSwitch(ParentControl{Track}.ParentControl{Switch}).click;
end;

{***********************************************}
constructor TALSwitch.Create(AOwner: TComponent);
begin
  inherited;
  CanFocus := True;
  SetAcceptsControls(False);
  AutoCapture := True;
  Cursor := crHandPoint;
  DisabledOpacity := 1;
  //--
  FOnChange := nil;
  FPressedThumbPos := TpointF.create(0,0);
  //--
  fScrollCapturedByMe := False;
  TMessageManager.DefaultManager.SubscribeToMessage(TALScrollCapturedMessage, ScrollCapturedByOtherHandler);
  //--
  FTransition := TALStateTransition.Create(0.16{ADefaultDuration});
  FTransition.OnChanged := TransitionChanged;
  //--
  FTrack := TTrack.Create(self);
  FTrack.Parent := self;
  FTrack.Stored := False;
  FTrack.SetSubComponent(True);
  FTrack.Name := 'Track';
  FTrack.Align := TalignLayout.Client;
  //--
  FThumb := TThumb.Create(FTrack);
  FThumb.Parent := FTrack;
  FThumb.Stored := False;
  FThumb.SetSubComponent(True);
  FThumb.Name := 'Thumb';
  AlignThumb;
end;

{***************************}
destructor TALSwitch.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TALScrollCapturedMessage, ScrollCapturedByOtherHandler);
  ALFreeAndNil(FTransition);
  inherited;
end;

{*************************}
procedure TALSwitch.Loaded;
begin
  inherited;
  Thumb.StateStyles.Transition.Assign(Transition);
  Track.StateStyles.Transition.Assign(Transition);
end;

{**********************************}
procedure TALSwitch.MakeBufDrawable;
begin
  Track.MakeBufDrawable;
  Thumb.MakeBufDrawable;
end;

{***********************************}
procedure TALSwitch.clearBufDrawable;
begin
  Track.clearBufDrawable;
  Thumb.clearBufDrawable;
end;

{****************************************}
function TALSwitch.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(52, 32);
end;

{****************************************}
function TALSwitch.GetDoubleBuffered: boolean;
begin
  result := Track.DoubleBuffered and Thumb.DoubleBuffered;
end;

{****************************************}
procedure TALSwitch.SetDoubleBuffered(const AValue: Boolean);
begin
  Track.DoubleBuffered := AValue;
  Thumb.DoubleBuffered := AValue;
end;

{***************************}
procedure TALSwitch.IsMouseOverChanged;
begin
  inherited;
  Track.FIsMouseOver := IsMouseOver;
  Thumb.FIsMouseOver := IsMouseOver;
  Track.IsMouseOverChanged;
  Thumb.IsMouseOverChanged;
end;

{***************************}
procedure TALSwitch.IsFocusedChanged;
begin
  inherited;
  Track.FIsFocused := IsFocused;
  Thumb.FIsFocused := IsFocused;
  Track.IsFocusedChanged;
  Thumb.IsFocusedChanged;
end;

{***************************}
procedure TALSwitch.PressedChanged;
begin
  inherited;
  Track.Pressed := Pressed;
  Thumb.Pressed := Pressed;
end;

{***************************}
procedure TALSwitch.EnabledChanged;
begin
  inherited;
  Track.enabled := enabled;
  Thumb.enabled := enabled;
end;

{***************************}
procedure TALSwitch.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

{***********************************************}
procedure TALSwitch.SetTransition(const Value: TALStateTransition);
begin
  FTransition.Assign(Value);
end;

{***********************************************}
procedure TALSwitch.TransitionChanged(ASender: TObject);
begin
  if csLoading in ComponentState then exit;
  Thumb.StateStyles.Transition.Assign(Transition);
  Track.StateStyles.Transition.Assign(Transition);
end;

{**********************************}
procedure TALSwitch.StartTransition;
begin
  Thumb.StateStyles.StartTransition;
  Track.StateStyles.StartTransition;
end;

{************************************************************************************}
procedure TALSwitch.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  if Pressed then begin
    fThumb.Align := TALignLayout.None;
    FPressedThumbPos := FThumb.Position.Point;
  end;
end;

{**************************************************************}
procedure TALSwitch.MouseMove(Shift: TShiftState; X, Y: Single);
begin
  inherited;
  if Pressed then begin

    if (not fScrollCapturedByMe) then begin
      If (abs(X - PressedPosition.X) > abs(Y - PressedPosition.Y)) and
         (abs(X - PressedPosition.X) > TALScrollEngine.DefaultTouchSlop) then begin
        PressedPosition := TpointF.Create(X,Y);
        fScrollCapturedByMe := true;
        TMessageManager.DefaultManager.SendMessage(self, TALScrollCapturedMessage.Create(true), True);
      end;
    end;

    if fScrollCapturedByMe then begin
      var LNewThumbPosX := FPressedThumbPos.x + (X - PressedPosition.X);
      LNewThumbPosX := min(LNewThumbPosX, GetMaxThumbPos);
      LNewThumbPosX := max(LNewThumbPosX, GetMinThumbPos);
      FThumb.Position.x :=LNewThumbPosX;
    end;

  end;
end;

{**********************************************************************************}
procedure TALSwitch.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  if fScrollCapturedByMe then begin
    FScrollCapturedByMe := False;
    var LChecked: Boolean;
    if fThumb.Position.x + (fThumb.Width / 2) < Track.Width / 2 then LChecked := False
    else LChecked := True;
    if LChecked <> Checked then begin
      if (transition.DelayClick) and
         (compareValue(FTransition.Duration,0.0,TEpsilon.Scale) > 0) then
        Thumb.StateStyles.TransitionClickDelayed := True;
      FTrack.Checked := LChecked;
      FThumb.Checked := LChecked;
      if not Thumb.StateStyles.TransitionClickDelayed then
        DoChange;
    end;
    fThumb.Align := TALignLayout.None;
    StartTransition;
  end;
end;

{*******************************}
procedure TALSwitch.DoMouseLeave;
begin
  inherited;
  if fScrollCapturedByMe then begin
    FScrollCapturedByMe := False;
    var LChecked: Boolean;
    if fThumb.Position.x + (fThumb.Width / 2) < Track.Width / 2 then LChecked := False
    else LChecked := True;
    if LChecked <> Checked then begin
      if (transition.DelayClick) and
         (compareValue(FTransition.Duration,0.0,TEpsilon.Scale) > 0) then
        Thumb.StateStyles.TransitionClickDelayed := True;
      FTrack.Checked := LChecked;
      FThumb.Checked := LChecked;
      if not Thumb.StateStyles.TransitionClickDelayed then
        DoChange;
    end;
    fThumb.Align := TALignLayout.None;
    StartTransition;
  end;
end;

{************************}
procedure TALSwitch.Click;
begin
  // If fScrollCapturedByMe is true, the MouseUp event will handle the task.
  if fScrollCapturedByMe then Exit
  // If Pressed is true, it means this event is triggered by MouseDown/MouseUp.
  // In this case, if a delay is requested for the click, apply the delay.
  else if (Pressed) and
          (Transition.DelayClick) and
          (compareValue(FTransition.Duration,0.0,TEpsilon.Scale) > 0) then begin
    Thumb.StateStyles.TransitionClickDelayed := True;
    var LChecked := not Checked;
    FTrack.Checked := LChecked;
    FThumb.Checked := LChecked;
    fThumb.Align := TALignLayout.None;
    StartTransition;
    exit;
  end
  // If Pressed is true, it means this event is triggered by MouseDown/MouseUp.
  else if Pressed then begin
    var LChecked := not Checked;
    FTrack.Checked := LChecked;
    FThumb.Checked := LChecked;
    fThumb.Align := TALignLayout.None;
    DoChange;
    inherited;
    StartTransition;
  end
  // if not Pressed, it means this event is triggered by event like TransitionAnimationFinish
  else begin
    DoChange;
    inherited;
    AlignThumb;
  end;
end;

{*****************************************************************************************}
procedure TALSwitch.ScrollCapturedByOtherHandler(const Sender: TObject; const M: TMessage);
begin
  if (Sender = self) then exit;
  {$IFDEF DEBUG}
  //ALLog(
  //  'TALSwitch.ScrollCapturedByOtherHandler',
  //  'Captured: ' + ALBoolToStrW(TALScrollCapturedMessage(M).Captured)+ ' | ' +
  //  'Pressed: ' + ALBoolToStrW(FPressed),
  //  TalLogType.verbose);
  {$ENDIF}
  if TALScrollCapturedMessage(M).Captured then begin
    {$IFDEF DEBUG}
    if fScrollCapturedByMe then
      raise Exception.Create('Error 6C41BEC8-3AE9-4EC0-9D80-117ED5697397');
    {$ENDIF}
    Pressed := False;
  end;
end;

{****************************************}
function TALSwitch.GetMinThumbPos: Single;
begin
  result := Track.Padding.left + fThumb.Margins.left;
end;

{****************************************}
function TALSwitch.GetMaxThumbPos: Single;
begin
  result := Track.Width - fThumb.Width - Track.Padding.Right - fThumb.Margins.Right;
end;

{*****************************}
procedure TALSwitch.AlignThumb;
begin
  if pressed or fScrollCapturedByMe then exit;
  If Checked then FThumb.Align := TALignLayout.right
  else FThumb.Align := TALignLayout.left;
end;

{**************************************}
function TALSwitch.GetChecked: boolean;
begin
  Result := FTrack.Checked and FThumb.Checked;
end;

{***************************************************}
procedure TALSwitch.SetChecked(const Value: Boolean);
begin
  if GetChecked <> Value then begin
    FTrack.Checked := Value;
    FThumb.Checked := Value;
    AlignThumb;
    DoChange;
  end;
end;

{***********************************}
constructor TALButton.TBaseStateStyle.Create(const AParent: TObject);
begin
  inherited Create(AParent);
  FDefaultText := '';
  FText := FDefaultText;
  //--
  if StateStyleParent <> nil then FTextSettings := TStateStyleTextSettings.Create(StateStyleParent.TextSettings)
  else if ControlParent <> nil then FTextSettings := TStateStyleTextSettings.Create(ControlParent.TextSettings)
  else FTextSettings := TStateStyleTextSettings.Create(nil);
  FTextSettings.OnChanged := TextSettingsChanged;
  //--
  Fill.DefaultColor := $FFE1E1E1;
  Fill.Color := Fill.DefaultColor;
  //--
  Stroke.DefaultColor := $FFADADAD;
  Stroke.Color := Stroke.DefaultColor;
  //--
  //FPriorSupersedeText
end;

{*************************************}
destructor TALButton.TBaseStateStyle.Destroy;
begin
  ALFreeAndNil(FTextSettings);
  inherited Destroy;
end;

{******************************************************}
procedure TALButton.TBaseStateStyle.Assign(Source: TPersistent);
begin
  if Source is TBaseStateStyle then begin
    BeginUpdate;
    Try
      Text := TBaseStateStyle(Source).text;
      TextSettings.Assign(TBaseStateStyle(Source).TextSettings);
      inherited Assign(Source);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{******************************}
procedure TALButton.TBaseStateStyle.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Text := DefaultText;
    TextSettings.reset;
  finally
    EndUpdate;
  end;
end;

{******************************************************}
procedure TALButton.TBaseStateStyle.Interpolate(const ATo: TALBaseStateStyle; const ANormalizedTime: Single);
begin
  {$IF defined(debug)}
  if (ATo <> nil) and (not (ATo is TBaseStateStyle)) then
    Raise Exception.Create('Error F3C72244-894F-4B67-AD86-F24DF5039927');
  {$ENDIF}
  BeginUpdate;
  try
    Inherited Interpolate(ATo, ANormalizedTime);
    if ATo <> nil then begin
      Text := TBaseStateStyle(ATo).Text;
      TextSettings.Interpolate(TBaseStateStyle(ATo).TextSettings, ANormalizedTime);
    end
    else if StateStyleParent <> nil then begin
      StateStyleParent.SupersedeNoChanges(true{ASaveState});
      try
        Text := StateStyleParent.Text;
        TextSettings.Interpolate(StateStyleParent.TextSettings, ANormalizedTime);
      finally
        StateStyleParent.RestoreStateNoChanges;
      end;
    end
    else if ControlParent <> nil then begin
      Text := ControlParent.Text;
      TextSettings.Interpolate(ControlParent.TextSettings, ANormalizedTime);
    end
    else begin
      Text := DefaultText;
      TextSettings.Interpolate(nil, ANormalizedTime);
    end;
  finally
    EndUpdate;
  end;
end;

{******************}
procedure TALButton.TBaseStateStyle.DoSupersede;
begin
  Inherited;
  //--
  FPriorSupersedeText := Text;
  //--
  if Text = '' then begin
    if StateStyleParent <> nil then Text := StateStyleParent.Text
    else Text := ControlParent.Text;
  end;
  TextSettings.SuperSede;
end;

{*********************************************************}
function TALButton.TBaseStateStyle.GetStateStyleParent: TBaseStateStyle;
begin
  {$IF defined(debug)}
  if (inherited StateStyleParent <> nil) and
     (not (inherited StateStyleParent is TBaseStateStyle)) then
    raise Exception.Create('StateStyleParent must be of type TBaseStateStyle');
  {$ENDIF}
  Result := TBaseStateStyle(inherited StateStyleParent);
end;

{*********************************************************}
function TALButton.TBaseStateStyle.GetControlParent: TALButton;
begin
  {$IF defined(debug)}
  if (inherited ControlParent <> nil) and
     (not (inherited ControlParent is TALButton)) then
    raise Exception.Create('ControlParent must be of type TALButton');
  {$ENDIF}
  Result := TALButton(inherited ControlParent);
end;

{*********************************************************}
procedure TALButton.TBaseStateStyle.SetText(const Value: string);
begin
  if FText <> Value then begin
    FText := Value;
    Change;
  end;
end;

{*******************************************************************************************}
procedure TALButton.TBaseStateStyle.SetTextSettings(const AValue: TStateStyleTextSettings);
begin
  FTextSettings.Assign(AValue);
end;

{***********************************************}
function TALButton.TBaseStateStyle.GetInherit: Boolean;
begin
  Result := inherited GetInherit and
            Text.IsEmpty and
            TextSettings.Inherit;
end;

{******************************************************************}
procedure TALButton.TBaseStateStyle.TextSettingsChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
function TALButton.TBaseStateStyle.IsTextStored: Boolean;
begin
  Result := FText <> FDefaultText;
end;

{**********************************************************}
function TALButton.TDisabledStateStyle.IsOpacityStored: Boolean;
begin
  Result := not SameValue(FOpacity, TControl.DefaultDisabledOpacity, TEpsilon.Scale);
end;

{********************************************************************}
procedure TALButton.TDisabledStateStyle.SetOpacity(const Value: Single);
begin
  if not SameValue(FOpacity, Value, TEpsilon.Scale) then begin
    FOpacity := Value;
    Change;
  end;
end;

{*********************************************}
constructor TALButton.TDisabledStateStyle.Create(const AParent: TObject);
begin
  inherited Create(AParent);
  FOpacity := TControl.DefaultDisabledOpacity;
end;

{****************************************************************}
procedure TALButton.TDisabledStateStyle.Assign(Source: TPersistent);
begin
  BeginUpdate;
  Try
    if Source is TDisabledStateStyle then
      Opacity := TDisabledStateStyle(Source).Opacity
    else
      Opacity := TControl.DefaultDisabledOpacity;
    inherited Assign(Source);
  Finally
    EndUpdate;
  End;
end;

{******************************}
procedure TALButton.TDisabledStateStyle.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Opacity := TControl.DefaultDisabledOpacity;
  finally
    EndUpdate;
  end;
end;

{******************************}
function TALButton.TDisabledStateStyle.GetInherit: Boolean;
begin
  // Opacity is not part of the GetInherit function because it updates the
  // disabledOpacity of the base control immediately every time it changes.
  // Essentially, it acts merely as a link to the disabledOpacity of the base control.
  Result := inherited GetInherit;
end;

{*************************************}
constructor TALButton.TStateStyles.Create(const AParent: TALButton);
begin
  inherited Create(AParent);
  //--
  FDisabled := TDisabledStateStyle.Create(AParent);
  FDisabled.OnChanged := DisabledChanged;
  //--
  FHovered := THoveredStateStyle.Create(AParent);
  FHovered.OnChanged := HoveredChanged;
  //--
  FPressed := TPressedStateStyle.Create(AParent);
  FPressed.OnChanged := PressedChanged;
  //--
  FFocused := TFocusedStateStyle.Create(AParent);
  FFocused.OnChanged := FocusedChanged;
end;

{*************************************}
destructor TALButton.TStateStyles.Destroy;
begin
  ALFreeAndNil(FDisabled);
  ALFreeAndNil(FHovered);
  ALFreeAndNil(FPressed);
  ALFreeAndNil(FFocused);
  inherited Destroy;
end;

{*********************************}
function TALButton.TStateStyles.CreateSavedState: TALPersistentObserver;
type
  TALButtonStateStylesClass = class of TStateStyles;
begin
  result := TALButtonStateStylesClass(classtype).Create(nil{AParent});
end;

{******************************************************}
procedure TALButton.TStateStyles.Assign(Source: TPersistent);
begin
  if Source is TStateStyles then begin
    BeginUpdate;
    Try
      Disabled.Assign(TStateStyles(Source).Disabled);
      Hovered.Assign(TStateStyles(Source).Hovered);
      Pressed.Assign(TStateStyles(Source).Pressed);
      Focused.Assign(TStateStyles(Source).Focused);
    Finally
      EndUpdate;
    End;
  end
  else
    ALAssignError(Source{ASource}, Self{ADest});
end;

{******************************}
procedure TALButton.TStateStyles.Reset;
begin
  BeginUpdate;
  Try
    inherited Reset;
    Disabled.reset;
    Hovered.reset;
    Pressed.reset;
    Focused.reset;
  finally
    EndUpdate;
  end;
end;

{******************************}
procedure TALButton.TStateStyles.ClearBufDrawable;
begin
  inherited;
  Disabled.ClearBufDrawable;
  Hovered.ClearBufDrawable;
  Pressed.ClearBufDrawable;
  Focused.ClearBufDrawable;
end;

{*******************************************************}
function TALButton.TStateStyles.GetCurrentRawStyle: TALBaseStateStyle;
begin
  if Not Parent.Enabled then Result := Disabled
  else if Parent.Pressed then Result := Pressed
  else if Parent.IsFocused then Result := Focused
  else if Parent.IsMouseOver then Result := Hovered
  else result := nil;
end;

{************************************************************************************}
function TALButton.TStateStyles.GetParent: TALButton;
begin
  Result := TALButton(inherited Parent);
end;

{************************************************************************************}
procedure TALButton.TStateStyles.SetDisabled(const AValue: TDisabledStateStyle);
begin
  FDisabled.Assign(AValue);
end;

{************************************************************************************}
procedure TALButton.TStateStyles.SetHovered(const AValue: THoveredStateStyle);
begin
  FHovered.Assign(AValue);
end;

{*******************************************************************************************}
procedure TALButton.TStateStyles.SetPressed(const AValue: TPressedStateStyle);
begin
  FPressed.Assign(AValue);
end;

{*******************************************************************************************}
procedure TALButton.TStateStyles.SetFocused(const AValue: TFocusedStateStyle);
begin
  FFocused.Assign(AValue);
end;

{**********************************************************}
procedure TALButton.TStateStyles.DisabledChanged(ASender: TObject);
begin
  Change;
end;

{************************************************************}
procedure TALButton.TStateStyles.HoveredChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
procedure TALButton.TStateStyles.PressedChanged(ASender: TObject);
begin
  Change;
end;

{******************************************************************}
procedure TALButton.TStateStyles.FocusedChanged(ASender: TObject);
begin
  Change;
end;

{***********************************************}
constructor TALButton.Create(AOwner: TComponent);
begin
  {$IF defined(ALDPK)}
  FPrevStateStyles := nil;
  {$ENDIF}
  FStateStyles := nil;
  //--
  inherited Create(AOwner);
  //--
  CanFocus := True;
  HitTest := True;
  AutoSize := True;
  Cursor := crHandPoint;
  //--
  var LFillChanged: TNotifyEvent := fill.OnChanged;
  fill.OnChanged := nil;
  Fill.DefaultColor := $ffe1e1e1;
  Fill.Color := Fill.DefaultColor;
  fill.OnChanged := LFillChanged;
  //--
  var LStrokeChanged: TNotifyEvent := stroke.OnChanged;
  stroke.OnChanged := Nil;
  Stroke.DefaultColor := $ffadadad;
  Stroke.Color := Stroke.DefaultColor;
  stroke.OnChanged := LStrokeChanged;
  //--
  var LTextSettingsChanged: TNotifyEvent := TextSettings.OnChanged;
  TextSettings.OnChanged := nil;
  TextSettings.Font.DefaultWeight := TFontWeight.medium;
  TextSettings.Font.Weight := TextSettings.Font.DefaultWeight;
  TextSettings.DefaultHorzAlign := TALTextHorzAlign.center;
  TextSettings.HorzAlign := TextSettings.DefaultHorzAlign;
  TextSettings.OnChanged := LTextSettingsChanged;
  //--
  var LPaddingChange: TNotifyEvent := Padding.OnChange;
  Padding.OnChange := nil;
  Padding.DefaultValue := TRectF.create(12{Left}, 6{Top}, 12{Right}, 6{Bottom});
  Padding.Rect := Padding.DefaultValue;
  padding.OnChange := LPaddingChange;
  //--
  {$IF defined(ALDPK)}
  FPrevStateStyles := TStateStyles.Create(nil);
  {$ENDIF}
  //--
  FStateStyles := TStateStyles.Create(self);
  FStateStyles.OnChanged := StateStylesChanged;
end;

{***************************}
destructor TALButton.Destroy;
begin
  {$IF defined(ALDPK)}
  ALFreeAndNil(FPrevStateStyles);
  {$ENDIF}
  ALFreeAndNil(FStateStyles);
  inherited Destroy;
end;

{*************************}
procedure TALButton.Loaded;

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  procedure _ConvertFontFamily(const AStateStyle: TBaseStateStyle);
  begin
    if (AStateStyle.TextSettings.Font.AutoConvert) and
       (AStateStyle.TextSettings.Font.Family <> '') and
       (not (csDesigning in ComponentState)) then
      AStateStyle.TextSettings.Font.Family := ALConvertFontFamily(AStateStyle.TextSettings.Font.Family);
  end;

begin
  _ConvertFontFamily(StateStyles.Disabled);
  _ConvertFontFamily(StateStyles.Hovered);
  _ConvertFontFamily(StateStyles.Pressed);
  _ConvertFontFamily(StateStyles.Focused);
  inherited Loaded;
end;

{*********************************************************}
function TALButton.CreateTextSettings: TALBaseTextSettings;
begin
  Result := TTextSettings.Create;
end;

{********************************************************}
function TALButton.GetTextSettings: TTextSettings;
begin
  Result := TTextSettings(Inherited TextSettings);
end;

{**********************************************************************}
procedure TALButton.SetTextSettings(const Value: TTextSettings);
begin
  Inherited SetTextSettings(Value);
end;

{*******************************************************}
procedure TALButton.SetName(const Value: TComponentName);
begin
  var LChangeText := not (csLoading in ComponentState) and (Name = Text) and
    ((Owner = nil) or not (csLoading in TComponent(Owner).ComponentState));
  inherited SetName(Value);
  if LChangeText then
    Text := Value;
end;

{*********************************************************************}
procedure TALButton.SetStateStyles(const AValue: TStateStyles);
begin
  FStateStyles.Assign(AValue);
end;

{******************************************************}
procedure TALButton.TextSettingsChanged(Sender: TObject);

  {~~~~~~~~~~~~~~~~~~}
  {$IF defined(ALDPK)}
  procedure _PropagateChanges(const APrevStateStyle: TBaseStateStyle; const AToStateStyle: TBaseStateStyle);
  begin

    if (not (csLoading in ComponentState)) and
       (not AToStateStyle.TextSettings.inherit) then begin

      if APrevStateStyle.TextSettings.font.Family = AToStateStyle.TextSettings.font.Family then AToStateStyle.TextSettings.font.Family := TextSettings.font.Family;
      if SameValue(APrevStateStyle.TextSettings.font.Size, AToStateStyle.TextSettings.font.Size, TEpsilon.fontSize) then AToStateStyle.TextSettings.font.Size := TextSettings.font.Size;
      if APrevStateStyle.TextSettings.font.Weight = AToStateStyle.TextSettings.font.Weight then AToStateStyle.TextSettings.font.Weight := TextSettings.font.Weight;
      if APrevStateStyle.TextSettings.font.Slant = AToStateStyle.TextSettings.font.Slant then AToStateStyle.TextSettings.font.Slant := TextSettings.font.Slant;
      if APrevStateStyle.TextSettings.font.Stretch = AToStateStyle.TextSettings.font.Stretch then AToStateStyle.TextSettings.font.Stretch := TextSettings.font.Stretch;
      if APrevStateStyle.TextSettings.font.Color = AToStateStyle.TextSettings.font.Color then AToStateStyle.TextSettings.font.Color := TextSettings.font.Color;
      if APrevStateStyle.TextSettings.font.AutoConvert = AToStateStyle.TextSettings.font.AutoConvert then AToStateStyle.TextSettings.font.AutoConvert := TextSettings.font.AutoConvert;

      if APrevStateStyle.TextSettings.Decoration.Kinds = AToStateStyle.TextSettings.Decoration.Kinds then AToStateStyle.TextSettings.Decoration.Kinds := TextSettings.Decoration.Kinds;
      if APrevStateStyle.TextSettings.Decoration.Style = AToStateStyle.TextSettings.Decoration.Style then AToStateStyle.TextSettings.Decoration.Style := TextSettings.Decoration.Style;
      if SameValue(APrevStateStyle.TextSettings.Decoration.ThicknessMultiplier, AToStateStyle.TextSettings.Decoration.ThicknessMultiplier, TEpsilon.Scale) then AToStateStyle.TextSettings.Decoration.ThicknessMultiplier := TextSettings.Decoration.ThicknessMultiplier;
      if APrevStateStyle.TextSettings.Decoration.Color = AToStateStyle.TextSettings.Decoration.Color then AToStateStyle.TextSettings.Decoration.Color := TextSettings.Decoration.Color;

    end;

    APrevStateStyle.TextSettings.font.Family := TextSettings.font.Family;
    APrevStateStyle.TextSettings.font.Size := TextSettings.font.Size;
    APrevStateStyle.TextSettings.font.Weight := TextSettings.font.Weight;
    APrevStateStyle.TextSettings.font.Slant := TextSettings.font.Slant;
    APrevStateStyle.TextSettings.font.Stretch := TextSettings.font.Stretch;
    APrevStateStyle.TextSettings.font.Color := TextSettings.font.Color;
    APrevStateStyle.TextSettings.font.AutoConvert := TextSettings.font.AutoConvert;

    APrevStateStyle.TextSettings.Decoration.Kinds := TextSettings.Decoration.Kinds;
    APrevStateStyle.TextSettings.Decoration.Style := TextSettings.Decoration.Style;
    APrevStateStyle.TextSettings.Decoration.ThicknessMultiplier := TextSettings.Decoration.ThicknessMultiplier;
    APrevStateStyle.TextSettings.Decoration.Color := TextSettings.Decoration.Color;

  end;
  {$ENDIF}

begin
  {$IF defined(ALDPK)}
  if (StateStyles <> nil) and (FPrevStateStyles <> nil) then begin
    _PropagateChanges(FPrevStateStyles.Disabled, StateStyles.Disabled);
    _PropagateChanges(FPrevStateStyles.Hovered, StateStyles.Hovered);
    _PropagateChanges(FPrevStateStyles.Pressed, StateStyles.Pressed);
    _PropagateChanges(FPrevStateStyles.Focused, StateStyles.Focused);
  end;
  {$ENDIF}
  inherited;
end;

{******************************************************}
procedure TALButton.SetXRadius(const Value: Single);

  {~~~~~~~~~~~~~~~~~~}
  {$IF defined(ALDPK)}
  procedure _PropagateChanges(const APrevStateStyle: TBaseStateStyle; const AToStateStyle: TBaseStateStyle);
  begin
    if (not (csLoading in ComponentState)) and
       (not AToStateStyle.StateLayer.HasFill) then begin
      if (SameValue(APrevStateStyle.StateLayer.XRadius, AToStateStyle.StateLayer.XRadius, TEpsilon.Vector)) then AToStateStyle.StateLayer.XRadius := XRadius;
    end;
    APrevStateStyle.StateLayer.XRadius := XRadius;
  end;
  {$ENDIF}

begin
  inherited;
  {$IF defined(ALDPK)}
  if (StateStyles <> nil) and (FPrevStateStyles <> nil) then begin
    _PropagateChanges(FPrevStateStyles.Disabled, StateStyles.Disabled);
    _PropagateChanges(FPrevStateStyles.Hovered, StateStyles.Hovered);
    _PropagateChanges(FPrevStateStyles.Pressed, StateStyles.Pressed);
    _PropagateChanges(FPrevStateStyles.Focused, StateStyles.Focused);
  end;
  {$ENDIF}
end;

{******************************************************}
procedure TALButton.SetYRadius(const Value: Single);

  {~~~~~~~~~~~~~~~~~~}
  {$IF defined(ALDPK)}
  procedure _PropagateChanges(const APrevStateStyle: TBaseStateStyle; const AToStateStyle: TBaseStateStyle);
  begin
    if (not (csLoading in ComponentState)) and
       (not AToStateStyle.StateLayer.HasFill) then begin
      if (SameValue(APrevStateStyle.StateLayer.YRadius, AToStateStyle.StateLayer.YRadius, TEpsilon.Vector)) then AToStateStyle.StateLayer.YRadius := YRadius;
    end;
    APrevStateStyle.StateLayer.YRadius := YRadius;
  end;
  {$ENDIF}

begin
  inherited;
  {$IF defined(ALDPK)}
  if (StateStyles <> nil) and (FPrevStateStyles <> nil) then begin
    _PropagateChanges(FPrevStateStyles.Disabled, StateStyles.Disabled);
    _PropagateChanges(FPrevStateStyles.Hovered, StateStyles.Hovered);
    _PropagateChanges(FPrevStateStyles.Pressed, StateStyles.Pressed);
    _PropagateChanges(FPrevStateStyles.Focused, StateStyles.Focused);
  end;
  {$ENDIF}
end;

{******************************************************}
procedure TALButton.StateStylesChanged(Sender: TObject);
begin
  clearBufDrawable;
  DisabledOpacity := StateStyles.Disabled.opacity;
  Repaint;
end;

{**************************************************}
procedure TALButton.IsMouseOverChanged;
begin
  inherited;
  StateStyles.startTransition;
  repaint;
end;

{********************************************}
procedure TALButton.IsFocusedChanged;
begin
  inherited;
  StateStyles.startTransition;
  repaint;
end;

{**************************************************}
procedure TALButton.PressedChanged;
begin
  inherited;
  StateStyles.startTransition;
  repaint;
end;

{************************}
procedure TALButton.Click;
begin
  if StateStyles.IsTransitionAnimationRunning and StateStyles.Transition.DelayClick then
    StateStyles.TransitionClickDelayed := True
  else
    inherited click;
end;

{***********************************}
procedure TALButton.clearBufDrawable;
begin
  {$IFDEF debug}
  if (FStateStyles <> nil) and
     (not (csDestroying in ComponentState)) and
     (ALIsDrawableNull(BufDrawable)) and // warn will be raise in inherited
     ((not ALIsDrawableNull(FStateStyles.Disabled.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Hovered.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Pressed.BufDrawable)) or
      (not ALIsDrawableNull(FStateStyles.Focused.BufDrawable))) then
    ALLog(Classname + '.clearBufDrawable', 'BufDrawable has been cleared | Name: ' + Name, TalLogType.warn);
  {$endif}
  if FStateStyles <> nil then
    FStateStyles.ClearBufDrawable;
  inherited clearBufDrawable;
end;

{**********************************}
procedure TALButton.MakeBufDrawable;
begin
  //--- Do not create BufDrawable if we are in the middle of a transition
  if StateStyles.IsTransitionAnimationRunning then
    exit;
  //--- Do not create BufDrawable if not DoubleBuffered
  if {$IF not DEFINED(ALDPK)}(not DoubleBuffered){$ELSE}False{$ENDIF} then begin
    clearBufDrawable;
    exit;
  end;
  //--
  inherited MakeBufDrawable;
  //--
  var LStateStyle := TBaseStateStyle(StateStyles.GetCurrentRawStyle);
  if LStateStyle = nil then exit;
  if LStateStyle.Inherit then exit;
  if (not ALIsDrawableNull(LStateStyle.BufDrawable)) then exit;
  LStateStyle.SupersedeNoChanges(true{ASaveState});
  try

    // Create the BufDrawable
    var LTextBroken: Boolean;
    var LAllTextDrawn: Boolean;
    var LElements: TALTextElements;
    var LScale: Single;
    if Abs(LStateStyle.Scale.x - 1) > Abs(LStateStyle.Scale.y - 1) then
      LScale := LStateStyle.Scale.x
    else
      LScale := LStateStyle.Scale.y;
    CreateBufDrawable(
      LStateStyle.BufDrawable, // var ABufDrawable: TALDrawable;
      LStateStyle.BufDrawableRect, // var ABufDrawableRect: TRectF;
      LTextBroken, // var ABufTextBroken: Boolean;
      LAllTextDrawn, // var ABufAllTextDrawn: Boolean;
      LElements, // var ABufElements: TALTextElements;
      ALGetScreenScale * LScale, // const AScale: Single;
      LStateStyle.Text, // const AText: String;
      LStateStyle.TextSettings.Font, // const AFont: TALFont;
      LStateStyle.TextSettings.Decoration, // const ADecoration: TALTextDecoration;
      LStateStyle.TextSettings.Font, // const AEllipsisFont: TALFont;
      LStateStyle.TextSettings.Decoration, // const AEllipsisDecoration: TALTextDecoration;
      LStateStyle.Fill, // const AFill: TALBrush;
      LStateStyle.StateLayer, // const AStateLayer: TALStateLayer;
      LStateStyle.Stroke, // const AStroke: TALStrokeBrush;
      LStateStyle.Shadow); // const AShadow: TALShadow);

    // LStateStyle.BufDrawableRect must include the LScale
    LStateStyle.BufDrawableRect.Top := LStateStyle.BufDrawableRect.Top * LScale;
    LStateStyle.BufDrawableRect.right := LStateStyle.BufDrawableRect.right * LScale;
    LStateStyle.BufDrawableRect.left := LStateStyle.BufDrawableRect.left * LScale;
    LStateStyle.BufDrawableRect.bottom := LStateStyle.BufDrawableRect.bottom * LScale;

    // Since LStateStyle.BufDrawableRect can have different dimensions than the main BufDrawableRect
    // (due to autosizing with different font sizes), we must center LStateStyle.BufDrawableRect
    // within the main BufDrawableRect to ensure that all changes are visually centered.
    var LMainDrawableRect := BufDrawableRect;
    LMainDrawableRect.Offset(-LMainDrawableRect.Left, -LMainDrawableRect.Top);
    var LCenteredRect := LStateStyle.BufDrawableRect.CenterAt(LMainDrawableRect);
    LStateStyle.BufDrawableRect.Offset(LCenteredRect.Left, LCenteredRect.top);

  finally
    LStateStyle.RestorestateNoChanges;
  end;
end;

{************************}
Procedure TALButton.DrawMultilineTextAdjustRect(const ACanvas: TALCanvas; const AOptions: TALMultiLineTextOptions; var ARect: TrectF; var ASurfaceSize: TSizeF);
begin

  // If we are drawing directly on the form, center ARect in LocalRect. This is necessary if, for example,
  // the 'to' font size is smaller than the 'from' font size.
  {$IF defined(ALSkiaCanvas)}
  If (Canvas <> nil) and (TSkCanvasCustom(Canvas).Canvas <> nil) and (TSkCanvasCustom(Canvas).Canvas.Handle = ACanvas) then
    ARect := ARect.CenterAt(LocalRect)
  else
  {$ENDIF}

end;

{************************}
procedure TALButton.Paint;
begin

  StateStyles.UpdateLastPaintedRawStyle;
  MakeBufDrawable;

  var LDrawable: TALDrawable;
  var LDrawableRect: TRectF;
  if StateStyles.IsTransitionAnimationRunning then begin
    LDrawable := ALNullDrawable;
    LDrawableRect := TRectF.Empty;
  end
  else begin
    var LStateStyle := TBaseStateStyle(StateStyles.GetCurrentRawStyle);
    if LStateStyle <> nil then begin
      LDrawable := LStateStyle.BufDrawable;
      LDrawableRect := LStateStyle.BufDrawableRect;
      if ALIsDrawableNull(LDrawable) then begin
        LDrawable := BufDrawable;
        LDrawableRect := BufDrawableRect;
      end;
    end
    else begin
      LDrawable := BufDrawable;
      LDrawableRect := BufDrawableRect;
    end;
  end;

  if ALIsDrawableNull(LDrawable) then begin

    var LCurrentAdjustedStateStyle := TBaseStateStyle(StateStyles.GetCurrentAdjustedStyle);
    if LCurrentAdjustedStateStyle = nil then begin
      inherited Paint;
      exit;
    end;

    // Using a matrix on the canvas results in smoother animations compared to using
    // Ascale with DrawMultilineText. This is because changes in scale affect the font size,
    // leading to rounding issues (I spent many hours looking for a way to avoid this).
    // If there is an animation, it appears jerky because the text position
    // shifts up or down with scale changes due to pixel alignment.
    var LCanvasSaveState: TCanvasSaveState := ALScaleAndCenterCanvas(
                                                Canvas, // Const ACanvas: TCanvas;
                                                AbsoluteRect, // Const AAbsoluteRect: TRectF;
                                                LCurrentAdjustedStateStyle.Scale.x, // Const AScaleX: Single;
                                                LCurrentAdjustedStateStyle.Scale.y, // Const AScaleY: Single;
                                                true); // Const ASaveState: Boolean);
    try

      {$IF DEFINED(ALSkiaCanvas)}

      // Canvas.AlignToPixel is used because when we call ALDrawDrawable,
      // we do LDstRect := ACanvas.AlignToPixel(LDstRect).
      // Therefore, when drawing directly on the canvas,
      // we must draw at the exact same position as when we call ALDrawDrawable.
      var LRect := Canvas.AlignToPixel(LocalRect);

      var LTextBroken: Boolean;
      var LAllTextDrawn: Boolean;
      var LElements: TALTextElements;
      DrawMultilineText(
        TSkCanvasCustom(Canvas).Canvas.Handle, // const ACanvas: TALCanvas;
        LRect, // var ARect: TRectF;
        LTextBroken, // out ATextBroken: Boolean;
        LAllTextDrawn, // out AAllTextDrawn: Boolean;
        LElements, // out AElements: TALTextElements;
        1{Ascale},
        AbsoluteOpacity, // const AOpacity: Single;
        LCurrentAdjustedStateStyle.Text, // const AText: String;
        LCurrentAdjustedStateStyle.TextSettings.Font, // const AFont: TALFont;
        LCurrentAdjustedStateStyle.TextSettings.Decoration, // const ADecoration: TALTextDecoration;
        LCurrentAdjustedStateStyle.TextSettings.EllipsisSettings.font, // const AEllipsisFont: TALFont;
        LCurrentAdjustedStateStyle.TextSettings.EllipsisSettings.Decoration, // const AEllipsisDecoration: TALTextDecoration;
        LCurrentAdjustedStateStyle.Fill, // const AFill: TALBrush;
        LCurrentAdjustedStateStyle.StateLayer, // const AStateLayer: TALStateLayer;
        LCurrentAdjustedStateStyle.Stroke, // const AStroke: TALStrokeBrush;
        LCurrentAdjustedStateStyle.Shadow); // const AShadow: TALShadow);

      {$ELSE}

      if StateStyles.IsTransitionAnimationRunning then begin

        var LRect := LocalRect;
        var LBufSurface: TALSurface;
        var LBufCanvas: TALCanvas;
        var LBufDrawable: TALDrawable;
        StateStyles.GetTransitionBufSurface(
            LRect, // var ARect: TrectF;
            LBufSurface, // out ABufSurface: TALSurface;
            LBufCanvas, // out ABufCanvas: TALCanvas;
            LBufDrawable); // out ABufDrawable: TALDrawable);

        ALClearCanvas(LBufCanvas, TAlphaColors.Null);

        var LTextBroken: Boolean;
        var LAllTextDrawn: Boolean;
        var LElements: TALTextElements;
        DrawMultilineText(
          LBufCanvas, // const ACanvas: TALCanvas;
          LRect, // out ARect: TRectF;
          LTextBroken, // out ATextBroken: Boolean;
          LAllTextDrawn, // out AAllTextDrawn: Boolean;
          LElements, // out AElements: TALTextElements;
          ALGetScreenScale{Ascale},
          1, // const AOpacity: Single;
          LCurrentAdjustedStateStyle.Text, // const AText: String;
          LCurrentAdjustedStateStyle.TextSettings.Font, // const AFont: TALFont;
          LCurrentAdjustedStateStyle.TextSettings.Decoration, // const ADecoration: TALTextDecoration;
          LCurrentAdjustedStateStyle.TextSettings.EllipsisSettings.font, // const AEllipsisFont: TALFont;
          LCurrentAdjustedStateStyle.TextSettings.EllipsisSettings.Decoration, // const AEllipsisDecoration: TALTextDecoration;
          LCurrentAdjustedStateStyle.Fill, // const AFill: TALBrush;
          LCurrentAdjustedStateStyle.StateLayer, // const AStateLayer: TALStateLayer;
          LCurrentAdjustedStateStyle.Stroke, // const AStroke: TALStrokeBrush;
          LCurrentAdjustedStateStyle.Shadow); // const AShadow: TALShadow);

        // The Shadow or Statelayer are not included in the dimensions of the LRect rectangle.
        // However, the LRect rectangle is offset by the dimensions of the shadow/Statelayer.
        LRect.Offset(-2*LRect.Left, -2*LRect.Top);

        // Since LStateStyle.BufDrawableRect can have different dimensions than the main BufDrawableRect
        // (due to autosizing with different font sizes), we must center LStateStyle.BufDrawableRect
        // within the main BufDrawableRect to ensure that all changes are visually centered.
        var LMainDrawableRect := BufDrawableRect;
        LMainDrawableRect.Offset(-LMainDrawableRect.Left, -LMainDrawableRect.Top);
        var LCenteredRect := LRect.CenterAt(LMainDrawableRect);
        LRect.Offset(LCenteredRect.Left, LCenteredRect.top);

        ALUpdateDrawableFromSurface(LBufSurface, LBufDrawable);
        ALDrawDrawable(
          Canvas, // const ACanvas: Tcanvas;
          LBufDrawable, // const ADrawable: TALDrawable;
          LRect.TopLeft, // const ADstTopLeft: TpointF;
          AbsoluteOpacity); // const AOpacity: Single)

      end

      {$IF defined(DEBUG)}
      else if not doublebuffered then
        raise Exception.Create('Controls that are not double-buffered only work when SKIA is enabled.');
      {$ENDIF}

      {$ENDIF}

    finally
      if LCanvasSaveState <> nil then
        Canvas.RestoreState(LCanvasSaveState);
    end;

    exit;
  end;

  ALDrawDrawable(
    Canvas, // const ACanvas: Tcanvas;
    LDrawable, // const ADrawable: TALDrawable;
    LDrawableRect.TopLeft, // const ATopLeft: TpointF;
    AbsoluteOpacity); // const AOpacity: Single);

end;

{*****************}
procedure Register;
begin
  RegisterComponents('Alcinoe', [TALAniIndicator, TALScrollBar, TALTrackBar, TALRangeTrackBar, TALCheckBox, TALRadioButton, TALSwitch, TALButton]);
  {$IFDEF ALDPK}
  UnlistPublishedProperty(TALAniIndicator, 'Size');
  UnlistPublishedProperty(TALAniIndicator, 'StyleName');
  UnlistPublishedProperty(TALAniIndicator, 'OnTap');
  //--
  UnlistPublishedProperty(TALScrollBar, 'Size');
  UnlistPublishedProperty(TALScrollBar, 'StyleName');
  UnlistPublishedProperty(TALScrollBar, 'OnTap');
  //--
  UnlistPublishedProperty(TALTrackBar, 'Size');
  UnlistPublishedProperty(TALTrackBar, 'StyleName');
  UnlistPublishedProperty(TALTrackBar, 'OnTap');
  //--
  UnlistPublishedProperty(TALRangeTrackBar, 'Size');
  UnlistPublishedProperty(TALRangeTrackBar, 'StyleName');
  UnlistPublishedProperty(TALRangeTrackBar, 'OnTap');
  //--
  UnlistPublishedProperty(TALCheckBox, 'Size');
  UnlistPublishedProperty(TALCheckBox, 'StyleName');
  UnlistPublishedProperty(TALCheckBox, 'OnTap');
  //--
  UnlistPublishedProperty(TALRadioButton, 'Size');
  UnlistPublishedProperty(TALRadioButton, 'StyleName');
  UnlistPublishedProperty(TALRadioButton, 'OnTap');
  //--
  UnlistPublishedProperty(TALSwitch, 'Size');
  UnlistPublishedProperty(TALSwitch, 'StyleName');
  UnlistPublishedProperty(TALSwitch, 'OnTap');
  //--
  UnlistPublishedProperty(TALButton, 'Size');
  UnlistPublishedProperty(TALButton, 'StyleName');
  UnlistPublishedProperty(TALButton, 'OnTap');
  //--
  UnlistPublishedProperty(TALTrackThumbGlyph, 'Size');
  UnlistPublishedProperty(TALTrackThumbGlyph, 'StyleName');
  UnlistPublishedProperty(TALTrackThumbGlyph, 'OnTap');
  UnlistPublishedProperty(TALTrackThumbGlyph, 'Locked');
  //--
  UnlistPublishedProperty(TALTrackThumb, 'Size');
  UnlistPublishedProperty(TALTrackThumb, 'StyleName');
  UnlistPublishedProperty(TALTrackThumb, 'OnTap');
  UnlistPublishedProperty(TALTrackThumb, 'Locked');
  UnlistPublishedProperty(TALTrackThumb, 'Anchors'); // not work https://quality.embarcadero.com/browse/RSP-15684
  UnlistPublishedProperty(TALTrackThumb, 'Align');
  UnlistPublishedProperty(TALTrackThumb, 'Position');
  UnlistPublishedProperty(TALTrackThumb, 'PopupMenu');
  UnlistPublishedProperty(TALTrackThumb, 'DragMode');
  UnlistPublishedProperty(TALTrackThumb, 'OnDragEnd');
  UnlistPublishedProperty(TALTrackThumb, 'OnDragEnter');
  UnlistPublishedProperty(TALTrackThumb, 'OnDragLeave');
  UnlistPublishedProperty(TALTrackThumb, 'OnDragOver');
  UnlistPublishedProperty(TALTrackThumb, 'OnDragDrop');
  UnlistPublishedProperty(TALTrackThumb, 'EnableDragHighlight');
  //--
  UnlistPublishedProperty(TALTrackBackground, 'Size');
  UnlistPublishedProperty(TALTrackBackground, 'StyleName');
  UnlistPublishedProperty(TALTrackBackground, 'OnTap');
  UnlistPublishedProperty(TALTrackBackground, 'Locked');
  UnlistPublishedProperty(TALTrackBackground, 'PopupMenu');
  UnlistPublishedProperty(TALTrackBackground, 'DragMode');
  UnlistPublishedProperty(TALTrackBackground, 'OnDragEnd');
  UnlistPublishedProperty(TALTrackBackground, 'OnDragEnter');
  UnlistPublishedProperty(TALTrackBackground, 'OnDragLeave');
  UnlistPublishedProperty(TALTrackBackground, 'OnDragOver');
  UnlistPublishedProperty(TALTrackBackground, 'OnDragDrop');
  UnlistPublishedProperty(TALTrackBackground, 'EnableDragHighlight');
  //--
  UnlistPublishedProperty(TALTrackHighlight, 'Size');
  UnlistPublishedProperty(TALTrackHighlight, 'StyleName');
  UnlistPublishedProperty(TALTrackHighlight, 'OnTap');
  UnlistPublishedProperty(TALTrackHighlight, 'Locked');
  UnlistPublishedProperty(TALTrackHighlight, 'Anchors'); // not work https://quality.embarcadero.com/browse/RSP-15684
  UnlistPublishedProperty(TALTrackHighlight, 'Align');
  UnlistPublishedProperty(TALTrackHighlight, 'Position');
  UnlistPublishedProperty(TALTrackHighlight, 'PopupMenu');
  UnlistPublishedProperty(TALTrackHighlight, 'DragMode');
  UnlistPublishedProperty(TALTrackHighlight, 'OnDragEnd');
  UnlistPublishedProperty(TALTrackHighlight, 'OnDragEnter');
  UnlistPublishedProperty(TALTrackHighlight, 'OnDragLeave');
  UnlistPublishedProperty(TALTrackHighlight, 'OnDragOver');
  UnlistPublishedProperty(TALTrackHighlight, 'OnDragDrop');
  UnlistPublishedProperty(TALTrackHighlight, 'EnableDragHighlight');
  //--
  UnlistPublishedProperty(TALSwitch.TThumb, 'Size');
  UnlistPublishedProperty(TALSwitch.TThumb, 'StyleName');
  UnlistPublishedProperty(TALSwitch.TThumb, 'HitTest');
  UnlistPublishedProperty(TALSwitch.TThumb, 'Tag');
  UnlistPublishedProperty(TALSwitch.TThumb, 'Touch');
  UnlistPublishedProperty(TALSwitch.TThumb, 'Locked');
  UnlistPublishedProperty(TALSwitch.TThumb, 'OnGesture');
  UnlistPublishedProperty(TALSwitch.TThumb, 'OnTap');
  //--
  UnlistPublishedProperty(TALSwitch.TTrack, 'Size');
  UnlistPublishedProperty(TALSwitch.TTrack, 'StyleName');
  UnlistPublishedProperty(TALSwitch.TTrack, 'HitTest');
  UnlistPublishedProperty(TALSwitch.TTrack, 'Tag');
  UnlistPublishedProperty(TALSwitch.TTrack, 'Touch');
  UnlistPublishedProperty(TALSwitch.TTrack, 'Locked');
  UnlistPublishedProperty(TALSwitch.TTrack, 'OnGesture');
  UnlistPublishedProperty(TALSwitch.TTrack, 'OnTap');
  {$ENDIF}
end;

initialization
  RegisterFmxClasses([TALAniIndicator, TALScrollBar, TALTrackBar, TALRangeTrackBar, TALCheckBox, TALRadioButton, TALSwitch, TALButton]);

end.
