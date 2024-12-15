object frmResample: TfrmResample
  Left = 1040
  Top = 171
  Caption = 'Resamplers test'
  ClientHeight = 674
  ClientWidth = 946
  Color = 16579836
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesigned
  ScreenSnap = True
  ShowHint = True
  OnDestroy = FormDestroy
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 206
    Height = 668
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object CubicSplitter1: TCubicSplitter
      Left = 0
      Top = 232
      Width = 206
      Height = 4
      Cursor = crVSplit
      Align = alTop
      Constraints.MaxHeight = 4
      Constraints.MinHeight = 4
      ResizeStyle = rsUpdate
    end
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 200
      Height = 226
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 0
      object Label2: TLabel
        Left = 0
        Top = 41
        Width = 200
        Height = 13
        Align = alTop
        Caption = 'Input image'
      end
      object Files: TCubicFileList
        Left = 0
        Top = 54
        Width = 200
        Height = 144
        Hint = 
          'Input image.'#13#10#13#10'Press the "Delete" key to delete the selected fi' +
          'le from disk.'
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        DoubleBuffered = True
        Mask = '*.jpg;*.png;*.bmp'
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowGlyphs = True
        ShowHint = True
        TabOrder = 1
        OnDblClick = FilesDblClick
      end
      object Path: TCubicPathEdit
        Left = 0
        Top = 0
        Width = 200
        Height = 41
        FileListBox = Files
        ShowCreateBtn = False
        Align = alTop
        Caption = 'Input folder'
        TabOrder = 0
      end
      object Panel5: TPanel
        Left = 0
        Top = 198
        Width = 200
        Height = 28
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object btnOrig: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 94
          Height = 22
          Hint = 'Show input image at its original size'
          Align = alLeft
          Caption = 'Show original'
          TabOrder = 0
          OnClick = btnOrigClick
        end
        object btnRefresh: TButton
          AlignWithMargins = True
          Left = 141
          Top = 3
          Width = 56
          Height = 22
          Hint = 'Refresh filelist'
          Align = alRight
          Caption = 'Refresh'
          TabOrder = 1
          OnClick = btnRefreshClick
        end
      end
    end
    object Panel3: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 239
      Width = 200
      Height = 426
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object btnJanStretch: TButton
        Left = 8
        Top = 80
        Width = 87
        Height = 34
        Action = actJanFxStretch
        TabOrder = 1
        WordWrap = True
      end
      object btnGr32: TButton
        Left = 8
        Top = 117
        Width = 87
        Height = 34
        Action = actGr32
        Caption = 'GR32'#13#10
        TabOrder = 2
        WordWrap = True
      end
      object SpinEdit1: TSpinEdit
        Left = 105
        Top = 55
        Width = 44
        Height = 22
        Hint = 'Filter type'
        MaxValue = 6
        MinValue = 0
        TabOrder = 14
        Value = 5
        OnChange = SpinEdit1Change
      end
      object spnGr32Filter: TSpinEdit
        Left = 107
        Top = 86
        Width = 44
        Height = 22
        Hint = 'Filter type'
        MaxValue = 3
        MinValue = 0
        TabOrder = 15
        Value = 0
      end
      object btnJanSmooth: TButton
        Left = 8
        Top = 43
        Width = 87
        Height = 34
        Action = actJanFXSmoothRes
        TabOrder = 0
        WordWrap = True
      end
      object btnHB: TButton
        Left = 62
        Top = 278
        Width = 87
        Height = 34
        Action = actHBResize
        TabOrder = 3
        Visible = False
        WordWrap = True
      end
      object btnMadshi: TButton
        Left = 101
        Top = 117
        Width = 87
        Height = 34
        Action = actMadshi
        Caption = 'Madshi madGraphics'
        TabOrder = 4
        WordWrap = True
      end
      object btnDephiStrtchDrw: TButton
        Left = 8
        Top = 154
        Width = 87
        Height = 34
        Action = actDephiStrtchDrw
        Caption = 'Canvas StretchDraw'
        TabOrder = 6
        WordWrap = True
      end
      object btnResizeMMX: TButton
        Left = 101
        Top = 154
        Width = 87
        Height = 34
        Action = actResizeMMX
        Caption = 'SmoothResize ASM'
        TabOrder = 7
        WordWrap = True
      end
      object btnMsThumbnails: TButton
        Left = 101
        Top = 229
        Width = 87
        Height = 34
        Action = actMsThumbnails
        Caption = 'Windows Thumbnails'
        TabOrder = 9
        WordWrap = True
      end
      object btnBitBlt: TButton
        Left = 8
        Top = 229
        Width = 87
        Height = 34
        Action = actBitBlt
        Caption = 'Windows StretchBlt'
        TabOrder = 8
        WordWrap = True
      end
      object btnDelphiScaleImg: TButton
        Left = 101
        Top = 191
        Width = 87
        Height = 34
        Action = actScaleImage
        Caption = 'VCL ScaleImage'
        TabOrder = 5
        WordWrap = True
      end
      object Button2: TButton
        Left = 8
        Top = 191
        Width = 87
        Height = 34
        Action = actFMXGraphics
        TabOrder = 10
        WordWrap = True
      end
      object chkTrimRam: TCubicCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 408
        Width = 194
        Height = 15
        Hint = 
          'Minimizes the amount to RAM used by application by swapping the ' +
          'unused pages back to disk.'#13#10'Used to get a fair comparison betwee' +
          'n algorithms.'
        Align = alBottom
        Caption = 'Trim Working Set'
        Checked = True
        State = cbChecked
        TabOrder = 11
        AutoSize = True
      end
      object btnHBQckDwn: TButton
        Left = 8
        Top = 318
        Width = 87
        Height = 34
        Hint = 'QuickDownscaleFac2'
        Caption = 'HB QuickDown'
        TabOrder = 12
        Visible = False
        WordWrap = True
        OnClick = btnHBQckDwnClick
      end
      object btnHBHard: TButton
        Left = 101
        Top = 318
        Width = 87
        Height = 34
        Hint = 'HardDownscaleFac2'
        Caption = 'HB HardDown'
        TabOrder = 13
        Visible = False
        WordWrap = True
        OnClick = btnHBHardClick
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 200
        Height = 31
        Align = alTop
        TabOrder = 16
        object lblNewWidth: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 108
          Height = 26
          Hint = 'Image'#39's new width (pix)'
          Align = alLeft
          Caption = 'Resize to (new width):'
          Layout = tlCenter
        end
        object spnWidth: TSpinEdit
          AlignWithMargins = True
          Left = 118
          Top = 4
          Width = 56
          Height = 23
          Hint = 'Image'#39's new width (pix)'
          Align = alLeft
          MaxValue = 2400000
          MinValue = 1
          TabOrder = 0
          Value = 1920
        end
      end
      object chkStretch: TCubicCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 387
        Width = 194
        Height = 15
        Hint = 'Stretch the preview image'
        Align = alBottom
        Caption = 'Stretch preview'
        Checked = True
        State = cbChecked
        TabOrder = 17
        OnClick = chkStretchClick
        AutoSize = True
      end
      object chkSaveOutput: TCubicCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 366
        Width = 194
        Height = 15
        Hint = 'Stretch the preview image'
        Align = alBottom
        Caption = 'Save output as BMP'
        TabOrder = 18
        OnClick = chkStretchClick
        AutoSize = True
      end
    end
  end
  object Panel7: TPanel
    Left = 212
    Top = 0
    Width = 734
    Height = 674
    Align = alClient
    Caption = 'Panel7'
    TabOrder = 1
    object Panel6: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 726
      Height = 666
      Align = alClient
      BevelOuter = bvNone
      Color = 3350025
      ParentBackground = False
      TabOrder = 0
      object Preview: TImage
        Left = 0
        Top = 0
        Width = 726
        Height = 666
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
      end
    end
  end
  object ActionList: TActionList
    Left = 198
    Top = 40
    object actJanFXSmoothRes: TAction
      Caption = 'JanFX SmoothResize'
      ShortCut = 16433
      OnExecute = actJanFXSmoothResExecute
    end
    object actJanFxStretch: TAction
      Caption = 'JanFx'#13#10'Stretch'
      ShortCut = 16434
      OnExecute = actJanFxStretchExecute
    end
    object actGr32: TAction
      Caption = 'GR32'#13#10'StretchImage'
      ShortCut = 16435
      OnExecute = actGr32Execute
    end
    object actHBResize: TAction
      Caption = 'HB'
      ShortCut = 16436
      OnExecute = actHBResizeExecute
    end
    object actMadshi: TAction
      Caption = 'Madshi'
      ShortCut = 16437
      OnExecute = actMadshiExecute
    end
    object actScaleImage: TAction
      Caption = 'Delphi ScaleImage'
      ShortCut = 16438
      OnExecute = actScaleImageExecute
    end
    object actDephiStrtchDrw: TAction
      Caption = 'Dephi StrtchDrw'
      ShortCut = 16439
      OnExecute = actDephiStrtchDrwExecute
    end
    object actResizeMMX: TAction
      Caption = 'Resize MMX'
      ShortCut = 16440
      OnExecute = actResizeMMXExecute
    end
    object actMsThumbnails: TAction
      Caption = 'Microsoft Thumbnails'
      ShortCut = 16432
      OnExecute = actMsThumbnailsExecute
    end
    object actBitBlt: TAction
      Caption = 'BitBlt'
      ShortCut = 16441
      OnExecute = actBitBltExecute
    end
    object actFMXGraphics: TAction
      Caption = 'FMX.Graphics'
      OnExecute = actFMXGraphicsExecute
    end
  end
end
