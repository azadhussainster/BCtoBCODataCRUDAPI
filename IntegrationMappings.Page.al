page 50101 "Integration Mappings"
{
    ApplicationArea = All;
    Caption = 'Integration Mappings';
    PageType = List;
    SourceTable = "Integration Mappings";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.';
                }

                field("API Setup Code"; Rec."API Setup Code")
                {
                    ToolTip = 'Specifies the value of the API Setup Code field.';
                }
            }
        }
    }
}
