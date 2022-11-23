pageextension 50100 "Item List Aza" extends "Item List"
{
    actions
    {
        addfirst(processing)
        {

            action(CreateItem)
            {
                Caption = 'Create Item(C)';
                ToolTip = 'Create Item on Remote Server';
                Image = Web;
                ApplicationArea = all;

                trigger OnAction()
                var
                    IntegrationMappings: Record "Integration Mappings";
                    APISetupAza: Record "API Setup Aza";
                    APIManagement: Codeunit "API Management";

                    JObjectPostData: JsonObject;
                    postData: Text;
                    APIResponse: Text;

                    ResponseJObject: JsonObject;
                    ResponseJToken: JsonToken;
                    CreatedItemNo: Text;
                    CreatedItemDesc: Text;
                begin
                    if IntegrationMappings.Get(Rec.RecordId.TableNo()) then
                        if APISetupAza.Get(IntegrationMappings."API Setup Code") then begin
                            JObjectPostData.Add('No', Rec."No.");
                            JObjectPostData.Add('Description', Rec.Description);
                            JObjectPostData.WriteTo(postData);
                            APIResponse := APIManagement.MakePostRequest(APISetupAza."Base URL", APIManagement.GetAuthToken(APISetupAza), postData)
                        end
                        else
                            Message('API Setup not found for API Setup Code:%1', IntegrationMappings."API Setup Code")
                    else
                        Message('Integration mapping not found for table:%1', Rec.RecordId.TableNo());


                    if APIResponse <> '' then
                        if ResponseJObject.ReadFrom(APIResponse) then begin
                            if ResponseJObject.Get('No', ResponseJToken) then
                                CreatedItemNo := ResponseJToken.AsValue().AsText();
                            if ResponseJObject.Get('Description', ResponseJToken) then
                                CreatedItemDesc := ResponseJToken.AsValue().AsText();

                            Message('Item Created. No:%1, Description:%2', CreatedItemNo, CreatedItemDesc);
                        end;


                end;
            }

            action(GetItemDetails)
            {
                Caption = 'Get Item(R)';
                ToolTip = 'Gets Item Details on Remote Server';
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
                    CreatedItemNo: Text;
                    CreatedItemDesc: Text;
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
                                CreatedItemNo := ResponseJToken.AsValue().AsText();
                            if ResponseJObject.Get('Description', ResponseJToken) then
                                CreatedItemDesc := ResponseJToken.AsValue().AsText();
                            if ResponseJObject.Get('@odata.etag', ResponseJToken) then
                                CreatedEtag := ResponseJToken.AsValue().AsText();

                            Message('Item Details are. No:%1, Description:%2, Etag:%3', CreatedItemNo, CreatedItemDesc, CreatedEtag);
                        end;


                end;
            }

            action(UpdateGLAccDetails)
            {
                Caption = 'Update Item(U)';
                ToolTip = 'Update Item Details on Remote Server';
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
                    CreatedItemNo: Text;
                    CreatedItemDesc: Text;
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
                            JObjectPostData.Add('Description', Rec.Description);
                            JObjectPostData.WriteTo(postData);

                            APIManagement.SetEtagHeaderForPatchRequest(CreatedEtag);
                            APIResponse := APIManagement.MakeAPIRequest(APISetupAza."Base URL", APIManagement.GetAuthToken(APISetupAza), postData, RequestType::PATCH, additionalURL);

                            if ResponseJObject.Get('No', ResponseJToken) then
                                CreatedItemNo := ResponseJToken.AsValue().AsText();
                            if ResponseJObject.Get('Description', ResponseJToken) then
                                CreatedItemDesc := ResponseJToken.AsValue().AsText();
                            Message('Updated Item Details are. No:%1, Description:%2, Etag:%3', CreatedItemNo, CreatedItemDesc, CreatedEtag);

                        end;


                end;
            }

            action(DeleteItem)
            {
                Caption = 'Delete Item(D)';
                ToolTip = 'Deletes selected Item on Remote Server';
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
                    CreatedItemNo: Text;
                    CreatedItemDesc: Text;
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
                                CreatedItemNo := ResponseJToken.AsValue().AsText();
                            if ResponseJObject.Get('Description', ResponseJToken) then
                                CreatedItemDesc := ResponseJToken.AsValue().AsText();

                            Message('Item Deleted');
                        end;


                end;
            }


        }
    }
    var
        DeleteLbl: label '(''%1'')', Comment = '%1 Item No to delete';
}