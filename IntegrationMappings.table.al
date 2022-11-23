table 50101 "Integration Mappings"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
            begin
                if AllObjWithCaption.Get(ObjectType::Table, "Table ID") then
                    "Table Name" := AllObjWithCaption."Object Caption";
            end;
        }
        field(2; "API Setup Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "API Setup Aza";
        }
        field(3; "Table Name"; text[249])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Table ID")
        {
            Clustered = true;
        }
    }



}