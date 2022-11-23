table 50100 "API Setup Aza"
{
    DataClassification = EndUserIdentifiableInformation;

    fields
    {
        field(1; "API Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'API Code';

        }
        field(2; "API Description"; Text[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'API Description';

        }
        field(3; "Base URL"; Text[250])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Base URL';

        }
        field(4; "Client ID"; Text[100])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Client ID';

        }

        field(5; "Scope URL"; Text[250])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Scope URL';

        }
        field(6; "Auth URL"; Text[250])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Auth URL';

        }
        field(7; "API Token"; text[250])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'API Token';
        }

        field(8; Active; Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Active';
        }

    }

    keys
    {
        key(Key1; "API Code")
        {
            Clustered = true;
        }
    }


    procedure SetAPIKey(NewAPIKey: Text[215])
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        StoredApiKey: Text;
    begin
        if IsolatedStorage.Contains(GetStorageKey(), DataScope::Module) then
            IsolatedStorage.Delete((GetStorageKey()));

        if CryptographyManagement.IsEncryptionEnabled() and CryptographyManagement.IsEncryptionPossible() then
            StoredApiKey := CryptographyManagement.EncryptText(NewAPIKey);

        IsolatedStorage.set(GetStorageKey(), StoredApiKey, DataScope::Module);
    end;

    procedure GetAPIKey(): Text
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        APIKey: Text;
        APIKeyOut: Text;
    begin
        if IsolatedStorage.Contains(GetStorageKey(), DataScope::Module) then begin
            IsolatedStorage.Get(GetStorageKey(), DataScope::Module, APIKey);
            if CryptographyManagement.IsEncryptionEnabled() and CryptographyManagement.IsEncryptionPossible() then
                APIKeyOut := CryptographyManagement.Decrypt(APIKey);
            exit(APIKeyOut);
        end;
    end;

    local procedure GetStorageKey(): Text
    begin
        exit(Rec."API Code");
    end;

    procedure GetToken(): Text;
    var
        // OAuth2: Codeunit OAuth2;
        // RedirectURL: Text;
        // Scopes: List of [Text];
        // MicrosoftOAuth2Url: Text;
        // Client_Id: Text;
        // Client_Secret: Text;
        // AccessToken: Text;
        APIManagement: Codeunit "API Management";

    begin
        //     Clear(AccessToken);
        //     Clear(Client_Secret);
        //     Clear(OAuth2);

        //     OAuth2.GetDefaultRedirectURL(RedirectURL);
        //     Scopes.Add("Scope URL");
        //     MicrosoftOAuth2Url := "Auth URL";
        //     Client_Id := "Client ID";
        //     Client_Secret := GetAPIKey();

        //     if not OAuth2.AcquireTokenWithClientCredentials(Client_Id, Client_Secret, MicrosoftOAuth2Url, '', Scopes, AccessToken) then
        //         Error(GetLastErrorText());
        //     exit(AccessToken);
        exit(APIManagement.GetAuthToken(Rec));
    end;

}