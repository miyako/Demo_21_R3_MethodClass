//%attributes = {"folder":"OldCode","lang":"en"}

Form.editEntity:=Form.dataClass.new()
Form.recordCanBeSaved:=True
Util_EntityLoad(Form.editEntity; Form.objectsNames)
FORM GOTO PAGE(2)
