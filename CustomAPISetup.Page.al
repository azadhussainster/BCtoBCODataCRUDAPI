page 50100 "Custom API Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Custom API Setup';
    PageType = List;
    SourceTable = "API Setup Aza";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("API Code"; Rec."API Code")
                {
                    ToolTip = 'Specifies the value of the API Code field.';
                }
                field("API Description"; Rec."API Description")
                {
                    ToolTip = 'Specifies the value of the API Description field.';
                }
                field("Auth URL"; Rec."Auth URL")
                {
                    ToolTip = 'Specifies the value of the Auth URL field.';
                }
                field("Scope URL"; Rec."Scope URL")
                {
                    ToolTip = 'Specifies the value of the Scope URL field.';
                }
                field("Base URL"; Rec."Base URL")
                {
                    ToolTip = 'Specifies the value of the Base URL field.';
                }

                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'Specifies the value of the Client ID field.';
                }
                field("APIKey"; APIKey)
                {
                    ToolTip = 'Specifies the value of the Scope URL field.';
                    Caption = 'Client Secret';
                    // ExtendedDatatype = Masked;

                    trigger OnValidate()
                    begin
                        Rec.SetAPIKey(APIKey);
                        Clear(APIKey);
                    end;
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.';
                }


            }
        }
    }
    actions
    {
        area(Processing)
        {

            action(GetApiKey)
            {
                Caption = 'Show API Key';
                ToolTip = 'Shows the API key from Isolated Storage';
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;


                trigger OnAction()
                begin
                    Message(Rec.GetAPIKey());
                end;
            }
            action(TestTokenGeneration)
            {
                Caption = 'Test Auth Token Generation';
                ToolTip = 'Gets the Auth Token from Auth Server';
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    JObjectToken: JsonObject;
                    JTokenAccessToken: JsonToken;
                    AccessTokenTxt: Text;
                begin
                    if JObjectToken.ReadFrom(Rec.GetToken()) then
                        if JObjectToken.Get('access_token', JTokenAccessToken) then begin
                            AccessTokenTxt := JTokenAccessToken.AsValue().AsText();
                            Message(AccessTokenTxt);
                        end
                        else
                            Message('Token can not be retrieved')
                    else
                        Message('Token can not be retrieved');

                end;
            }
            // action(CreateItem)
            // {
            //     Caption = 'Create Sample Item';
            //     ToolTip = 'Gets the Auth Token from Auth Server';
            //     Image = Web;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;

            //     trigger OnAction()
            //     var
            //         APIManagement: Codeunit "API Management";
            //     begin
            //         // Message(APIManagement.CreateRequest_POST('https://api.businesscentral.dynamics.com/v2.0/0dca7849-754b-4305-9e47-0b59350d40a6/Sandbox1/ODataV4/Company(''CYNO%20MEDICAMENTS'')/Chart_of_Accounts', Rec.GetToken()));
            //         Message('Not Implemented');
            //     end;
        }
    }



    trigger OnAfterGetCurrRecord()
    begin
        Clear(APIKey);
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(APIKey);
    end;

    trigger OnOpenPage()
    begin
        Clear(APIKey);
    end;

    var
        APIKey: Text[215];
}
