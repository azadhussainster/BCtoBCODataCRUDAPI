pageextension 50101 "Chart Of Accounts Aza" extends "Chart of Accounts"
{

    actions
    {
        addfirst(processing)
        {
            action(CreateGLAccount)
            {
                Caption = 'Create GL Account(C)';
                ToolTip = 'Create GL Account on Remote Server';
                Image = Web;
                ApplicationArea = all;

                trigger OnAction()
                var
                    IntegrationMappings: Record "Integration Mappings";
                    APISetupAza: Record "API Setup Aza";
                    APIManagement: Codeunit "API Management";
                    RequestType: Enum "Http Request Type";

                    JObjectPostData: JsonObject;
                    postData: Text;
                    APIResponse: Text;

                    ResponseJObject: JsonObject;
                    ResponseJToken: JsonToken;
                    CreatedAccNo: Text;
                    CreatedAccName: Text;
                begin
                    if IntegrationMappings.Get(Rec.RecordId.TableNo()) then
                        if APISetupAza.Get(IntegrationMappings."API Setup Code") then begin
                            JObjectPostData.Add('No', Rec."No.");
                            JObjectPostData.Add('Name', Rec.Name);
                            JObjectPostData.WriteTo(postData);
                            // APIResponse := APIManagement.MakePostRequest(APISetupAza."Base URL", APIManagement.GetAuthToken(APISetupAza), postData)
                            APIResponse := APIManagement.MakeAPIRequest(APISetupAza."Base URL", APIManagement.GetAuthToken(APISetupAza), postData, RequestType::POST, '')
                        end
                        else
                            Message('API Setup not found for API Setup Code:%1', IntegrationMappings."API Setup Code")
                    else
                        Message('Integration mapping not found for table:%1', Rec.RecordId.TableNo());


                    if APIResponse <> '' then
                        if ResponseJObject.ReadFrom(APIResponse) then begin
                            if ResponseJObject.Get('No', ResponseJToken) then
                                CreatedAccNo := ResponseJToken.AsValue().AsText();
                            if ResponseJObject.Get('Name', ResponseJToken) then
                                CreatedAccName := ResponseJToken.AsValue().AsText();

                            Message('GL Account Created. No:%1, Name:%2', CreatedAccNo, CreatedAccName);
                        end;


                end;
            }

            action(GetGLAccDetails)
            {
                Caption = 'Get GL Account(R)';
                ToolTip = 'Gets GL Account Details on Remote Server';
                Image = Web;
                ApplicationArea = all;

                trigger OnAction()
                var
                    IntegrationMappings: Record "Integration Mappings";
                    APISetupAza: Record "API Setup Aza";
                    APIManagement: Codeunit "API Management";

                    RequestType: Enum "Http Request Type";
                    additionalURL: Text;
                    APIResponse: Text;

                    ResponseJObject: JsonObject;
                    ResponseJToken: JsonToken;
                    CreatedAccNo: Text;
                    CreatedAccName: Text;
                    CreatedEtag: Text;
                begin
                    if IntegrationMappings.Get(Rec.RecordId.TableNo()) then
                        if APISetupAza.Get(IntegrationMappings."API Setup Code") then begin
                            additionalURL := StrSubstNo(DeleteLbl, Rec."No.");
                            APIResponse := APIManagement.MakeAPIRequest(APISetupAza."Base URL", APIManagement.GetAuthToken(APISetupAza), '', RequestType::GET, additionalURL)
                        end
                        else
                            Message('API Setup not found for API Setup Code:%1', IntegrationMappings."API Setup Code")
                    else
                        Message('Integration mapping not found for table:%1', Rec.RecordId.TableNo());


                    if APIResponse <> '' then
                        if ResponseJObject.ReadFrom(APIResponse) then begin
                            if ResponseJObject.Get('No', ResponseJToken) then
                                CreatedAccNo := ResponseJToken.AsValue().AsText();
                            if ResponseJObject.Get('Name', ResponseJToken) then
                                CreatedAccName := ResponseJToken.AsValue().AsText();
                            if ResponseJObject.Get('@odata.etag', ResponseJToken) then
                                CreatedEtag := ResponseJToken.AsValue().AsText();

                            Message('GL Account Details are. No:%1, Name:%2, Etag:%3', CreatedAccNo, CreatedAccName, CreatedEtag);
                        end;


                end;
            }

            action(UpdateGLAccDetails)
            {
                Caption = 'Update GL Account(U)';
                ToolTip = 'Update GL Account Details on Remote Server';
                Image = Web;
                ApplicationArea = all;

                trigger OnAction()
                var
                    IntegrationMappings: Record "Integration Mappings";
                    APISetupAza: Record "API Setup Aza";
                    APIManagement: Codeunit "API Management";
                    JObjectPostData: JsonObject;
                    postData: Text;

                    RequestType: Enum "Http Request Type";
                    additionalURL: Text;
                    APIResponse: Text;

                    ResponseJObject: JsonObject;
                    ResponseJToken: JsonToken;
                    CreatedAccNo: Text;
                    CreatedAccName: Text;
                    CreatedEtag: Text;
                begin
                    if IntegrationMappings.Get(Rec.RecordId.TableNo()) then
                        if APISetupAza.Get(IntegrationMappings."API Setup Code") then begin
                            additionalURL := StrSubstNo(DeleteLbl, Rec."No.");
                            APIResponse := APIManagement.MakeAPIRequest(APISetupAza."Base URL", APIManagement.GetAuthToken(APISetupAza), '', RequestType::GET, additionalURL)
                        end
                        else
                            Error('API Setup not found for API Setup Code:%1', IntegrationMappings."API Setup Code")
                    else
                        Error('Integration mapping not found for table:%1', Rec.RecordId.TableNo());


                    if APIResponse <> '' then
                        if ResponseJObject.ReadFrom(APIResponse) then begin
                            if ResponseJObject.Get('@odata.etag', ResponseJToken) then
                                CreatedEtag := ResponseJToken.AsValue().AsText();
                            additionalURL := StrSubstNo(DeleteLbl, Rec."No.");
                            JObjectPostData.Add('Name', Rec.Name);
                            JObjectPostData.WriteTo(postData);

                            APIManagement.SetEtagHeaderForPatchRequest(CreatedEtag);
                            APIResponse := APIManagement.MakeAPIRequest(APISetupAza."Base URL", APIManagement.GetAuthToken(APISetupAza), postData, RequestType::PATCH, additionalURL);

                            if ResponseJObject.ReadFrom(APIResponse) then begin
                                if ResponseJObject.Get('No', ResponseJToken) then
                                    CreatedAccNo := ResponseJToken.AsValue().AsText();
                                if ResponseJObject.Get('Name', ResponseJToken) then
                                    CreatedAccName := ResponseJToken.AsValue().AsText();
                                Message('Updated GL Account Details are. No:%1, Name:%2, Etag:%3', CreatedAccNo, CreatedAccName, CreatedEtag);
                            end
                        end;


                end;
            }

            action(DeleteGLAccount)
            {
                Caption = 'Delete GL Account(D)';
                ToolTip = 'Delete GL Account on Remote Server';
                Image = Web;
                ApplicationArea = all;

                trigger OnAction()
                var
                    IntegrationMappings: Record "Integration Mappings";
                    APISetupAza: Record "API Setup Aza";
                    APIManagement: Codeunit "API Management";

                    RequestType: Enum "Http Request Type";
                    additionalURL: Text;
                    APIResponse: Text;

                    ResponseJObject: JsonObject;
                    ResponseJToken: JsonToken;
                    CreatedAccNo: Text;
                    CreatedAccName: Text;
                begin
                    if IntegrationMappings.Get(Rec.RecordId.TableNo()) then
                        if APISetupAza.Get(IntegrationMappings."API Setup Code") then begin
                            additionalURL := StrSubstNo(DeleteLbl, Rec."No.");
                            APIResponse := APIManagement.MakeAPIRequest(APISetupAza."Base URL", APIManagement.GetAuthToken(APISetupAza), '', RequestType::DELETE, additionalURL)
                        end
                        else
                            Message('API Setup not found for API Setup Code:%1', IntegrationMappings."API Setup Code")
                    else
                        Message('Integration mapping not found for table:%1', Rec.RecordId.TableNo());


                    if APIResponse <> '' then
                        if ResponseJObject.ReadFrom(APIResponse) then begin
                            if ResponseJObject.Get('No', ResponseJToken) then
                                CreatedAccNo := ResponseJToken.AsValue().AsText();
                            if ResponseJObject.Get('Name', ResponseJToken) then
                                CreatedAccName := ResponseJToken.AsValue().AsText();

                            Message('GL Account Created. No:%1, Name:%2', CreatedAccNo, CreatedAccName);
                        end;


                end;
            }

        }
    }
    var
        DeleteLbl: label '(''%1'')', Comment = '%1 GL Account No to delete';
}