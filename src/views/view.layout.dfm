inherited viewLayout: TviewLayout
  Caption = 'Layout'
  PixelsPerInch = 96
  TextHeight = 15
  inherited pnlContent: TPanel
    inherited sbxContent: TScrollBox
      object pnlSettings: TPanel
        Left = 0
        Top = 21
        Width = 878
        Height = 519
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object lblLog: TLabel
          Left = 20
          Top = 152
          Width = 20
          Height = 15
          Caption = 'Log'
        end
        object lblVclStyle: TLabel
          Left = 208
          Top = 300
          Width = 49
          Height = 15
          Caption = 'VCL Style'
        end
        object grpDisplayMode: TRadioGroup
          Left = 20
          Top = 20
          Width = 205
          Height = 53
          Caption = 'Display Mode'
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Docked'
            'Overlay')
          TabOrder = 0
          OnClick = grpDisplayModeClick
        end
        object grpPlacement: TRadioGroup
          Left = 20
          Top = 88
          Width = 205
          Height = 53
          Caption = 'Placement'
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Left'
            'Right')
          TabOrder = 2
          OnClick = grpPlacementClick
        end
        object grpCloseStyle: TRadioGroup
          Left = 244
          Top = 20
          Width = 205
          Height = 53
          Caption = 'Close Style'
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Collapse'
            'Compact')
          TabOrder = 1
          OnClick = grpCloseStyleClick
        end
        object lstLog: TListBox
          Left = 20
          Top = 173
          Width = 205
          Height = 108
          ItemHeight = 15
          TabOrder = 4
        end
        object grpAnimation: TGroupBox
          Left = 244
          Top = 88
          Width = 205
          Height = 193
          Caption = 'Animation'
          TabOrder = 3
          object lblAnimationDelay: TLabel
            Left = 16
            Top = 56
            Width = 111
            Height = 15
            Caption = 'Animation Delay (15)'
          end
          object lblAnimationStep: TLabel
            Left = 16
            Top = 123
            Width = 105
            Height = 15
            Caption = 'Animation Step (20)'
          end
          object chkUseAnimation: TCheckBox
            Left = 16
            Top = 24
            Width = 97
            Height = 17
            Caption = 'Use Animation'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chkUseAnimationClick
          end
          object trkAnimationDelay: TTrackBar
            Left = 8
            Top = 77
            Width = 177
            Height = 36
            Max = 15
            Min = 1
            Position = 3
            TabOrder = 1
            OnChange = trkAnimationDelayChange
          end
          object trkAnimationStep: TTrackBar
            Left = 8
            Top = 144
            Width = 177
            Height = 33
            Max = 15
            Min = 1
            Position = 4
            TabOrder = 2
            OnChange = trkAnimationStepChange
          end
        end
        object chkCloseOnMenuClick: TCheckBox
          Left = 20
          Top = 300
          Width = 161
          Height = 17
          Caption = 'Close on Menu Click'
          TabOrder = 5
          OnClick = chkCloseOnMenuClickClick
        end
        object cbxVclStyles: TComboBox
          Left = 270
          Top = 297
          Width = 179
          Height = 23
          Style = csDropDownList
          TabOrder = 6
          OnClick = cbxVclStylesClick
        end
      end
    end
    inherited pnlTitle: TPanel
      inherited lblTitle: TSkLabel
        Words = <
          item
            Caption = 'Layout'
          end>
      end
    end
  end
end
