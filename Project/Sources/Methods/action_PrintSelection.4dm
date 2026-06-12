//%attributes = {"folder":"OldCode","lang":"en"}
USE ENTITY SELECTION(Form.displayedSelection)
FORM SET OUTPUT((Form.dataClassPtr)->; "List")
PRINT SELECTION((Form.dataClassPtr)->)
