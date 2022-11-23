codeunit 50100 "API Management"
{
    trigger OnRun()
    begin

    end;

    procedure GetAuthToken(APISetupAza: Record "API Setup Aza"): Text
    var
        TypeHelper: Codeunit "Type Helper";
        TempBlob: Codeunit "Temp Blob";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpHeadersRequest: HttpHeaders;
        HttpHeadersContent: HttpHeaders;
        HttpContentBody: HttpContent;

        UrlEncodedBodyTxt: Text;
        ScopeURL: Text;
        ClientID: Text;
        Client_Secret: Text;

        ResponseInStream: InStream;
        IsSuccessful: Boolean;
        HttpResponseMessage: HttpResponseMessage;
        StatusCode: Text;
        Jobject: JsonObject;

        TokenTxt: Text;
    begin

        //Body
        HttpRequestMessage.GetHeaders(HttpHeadersRequest);
        HttpHeadersRequest.Clear();
        HttpHeadersRequest.Add('Accept', '*/*');

        ScopeURL := APISetupAza."Scope URL";
        ClientID := APISetupAza."Client ID";
        Client_Secret := APISetupAza.GetAPIKey();

        UrlEncodedBodyTxt += 'grant_type=client_credentials&';
        UrlEncodedBodyTxt += 'scope=' + TypeHelper.UrlEncode(ScopeURL) + '&';
        UrlEncodedBodyTxt += 'client_id=' + TypeHelper.UrlEncode(ClientID) + '&';
        UrlEncodedBodyTxt += 'client_secret=' + TypeHelper.UrlEncode(Client_Secret);
        HttpContentBody.WriteFrom(UrlEncodedBodyTxt);

        //Post HEADERS
        HttpContentBody.GetHeaders(HttpHeadersContent);
        HttpHeadersContent.Clear();
        HttpHeadersContent.Remove('Content-Type');
        HttpHeadersContent.Add('Content-Type', 'application/x-www-form-urlencoded');

        //POST METHOD
        HttpRequestMessage.Content := HttpContentBody;
        HttpRequestMessage.SetRequestUri(APISetupAza."Auth URL");
        HttpRequestMessage.Method := 'POST';


        Clear(TempBlob);
        TempBlob.CreateInStream(ResponseInStream);

        IsSuccessful := HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

        if not IsSuccessful then exit('An API call with the provided header has failed.');
        if not HttpResponseMessage.IsSuccessStatusCode() then begin
            StatusCode := Format(HttpResponseMessage.HttpStatusCode()) + ' - ' + HttpResponseMessage.ReasonPhrase;
            exit('The request has failed with status code ' + StatusCode);
        end;

        if not HttpResponseMessage.Content().ReadAs(ResponseInStream) then exit('The response message cannot be processed.');
        if not JObject.ReadFrom(ResponseInStream) then exit('Cannot read JSON response.');

        //API response
        JObject.WriteTo(TokenTxt);
        exit(TokenTxt);

    end;


    procedure MakePostRequest(RequestUrl: Text; AccessToken: Text; postData: Text): Text
    var
        TempBlob: Codeunit "Temp Blob";
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        Content: HttpContent;
        HttpHeadersContent: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        JObject: JsonObject;
        ResponseStream: InStream;
        APICallResponseMessage: Text;
        StatusCode: Text;
        IsSuccessful: Boolean;
        JObjectToken: JsonObject;
        JTokenAccessToken: JsonToken;
        AccessTokenTxt: Text;



    begin

        if JObjectToken.ReadFrom(AccessToken) then
            if JObjectToken.Get('access_token', JTokenAccessToken) then
                AccessTokenTxt := JTokenAccessToken.AsValue().AsText()
            else
                Message('Token can not be retrieved')
        else
            Message('Token can not be retrieved');
        //BODY
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Authorization', 'Bearer ' + AccessTokenTxt);
        RequestHeaders.Add('Accept', 'application/json');
        Content.WriteFrom(postData);

        //GET HEADERS
        Content.GetHeaders(HttpHeadersContent);
        HttpHeadersContent.Clear();
        HttpHeadersContent.Remove('Content-Type');
        HttpHeadersContent.Add('Content-Type', 'application/json; charset=UTF-8');


        //POST METHOD
        RequestMessage.Content := Content;
        RequestMessage.SetRequestUri(RequestUrl);
        RequestMessage.Method := 'POST';

        Clear(TempBlob);
        TempBlob.CreateInStream(ResponseStream);

        IsSuccessful := Client.Send(RequestMessage, ResponseMessage);

        if not IsSuccessful then exit('An API call with the provided header has failed.');
        if not ResponseMessage.IsSuccessStatusCode() then begin
            StatusCode := Format(ResponseMessage.HttpStatusCode()) + ' - ' + ResponseMessage.ReasonPhrase;
            exit('The request has failed with status code ' + StatusCode);
        end;

        if not ResponseMessage.Content().ReadAs(ResponseStream) then exit('The response message cannot be processed.');
        if not JObject.ReadFrom(ResponseStream) then exit('Cannot read JSON response.');

        //API response
        JObject.WriteTo(APICallResponseMessage);
        // APICallResponseMessage := APICallResponseMessage.Replace(',', '\');
        exit(APICallResponseMessage);
    end;

    procedure MakeAPIRequest(RequestUrl: Text; AccessToken: Text; postData: Text; RequestType: Enum "Http Request Type"; AdditionlURL: Text): Text
    var
        TempBlob: Codeunit "Temp Blob";
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        Content: HttpContent;
        HttpHeadersContent: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        JObject: JsonObject;
        ResponseStream: InStream;
        APICallResponseMessage: Text;
        StatusCode: Text;
        IsSuccessful: Boolean;
        JObjectToken: JsonObject;
        JTokenAccessToken: JsonToken;
        AccessTokenTxt: Text;



    begin

        if JObjectToken.ReadFrom(AccessToken) then
            if JObjectToken.Get('access_token', JTokenAccessToken) then
                AccessTokenTxt := JTokenAccessToken.AsValue().AsText()
            else
                Message('Token can not be retrieved')
        else
            Message('Token can not be retrieved');
        //BODY
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Authorization', 'Bearer ' + AccessTokenTxt);
        RequestHeaders.Add('Accept', 'application/json');
        Content.WriteFrom(postData);

        //HEADERS
        Content.GetHeaders(HttpHeadersContent);
        HttpHeadersContent.Clear();
        HttpHeadersContent.Remove('Content-Type');
        HttpHeadersContent.Add('Content-Type', 'application/json; charset=UTF-8');


        //METHOD
        case RequestType of
            RequestType::POST:
                begin
                    RequestMessage.Content := Content;
                    RequestMessage.SetRequestUri(RequestUrl);
                    RequestMessage.Method := 'POST';

                end;
            RequestType::GET:
                begin
                    RequestMessage.SetRequestUri(RequestUrl + AdditionlURL);
                    RequestMessage.Method := 'GET';
                end;
            RequestType::DELETE:
                begin
                    RequestMessage.SetRequestUri(RequestUrl + AdditionlURL);
                    RequestMessage.Method := 'DELETE';
                end;
            RequestType::PATCH:
                begin
                    RequestMessage.Content := Content;
                    RequestHeaders.Add('If-Match', EtagGlobal);
                    RequestMessage.SetRequestUri(RequestUrl + AdditionlURL);
                    RequestMessage.Method := 'PATCH';
                end;
        end;

        Clear(TempBlob);
        TempBlob.CreateInStream(ResponseStream);

        IsSuccessful := Client.Send(RequestMessage, ResponseMessage);

        case RequestType of
            RequestType::POST:
                if ResponseMessage.HttpStatusCode() = 201 then
                    Message('record created successfully');

            RequestType::GET:
                if ResponseMessage.HttpStatusCode() = 200 then
                    Message('record retrieved successfully');
            RequestType::DELETE:
                if ResponseMessage.HttpStatusCode() = 204 then
                    Message('record deleted successfully');
            RequestType::PATCH:
                if ResponseMessage.HttpStatusCode() = 204 then
                    Message('record updated successfully');

        end;

        if not IsSuccessful then exit('An API call with the provided header has failed.');
        if not ResponseMessage.IsSuccessStatusCode() then begin
            StatusCode := Format(ResponseMessage.HttpStatusCode()) + ' - ' + ResponseMessage.ReasonPhrase;
            exit('The request has failed with status code ' + StatusCode);
        end;

        if not ResponseMessage.Content().ReadAs(ResponseStream) then exit('The response message cannot be processed.');
        if not JObject.ReadFrom(ResponseStream) then exit('Cannot read JSON response.');

        //API response
        JObject.WriteTo(APICallResponseMessage);
        // APICallResponseMessage := APICallResponseMessage.Replace(',', '\');
        exit(APICallResponseMessage);
    end;

    procedure SetEtagHeaderForPatchRequest(Etag: Text)
    begin
        EtagGlobal := Etag;
    end;

    var
        EtagGlobal: Text;

}