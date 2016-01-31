FUNCTION CrabKeyValue::INIT
    SELF.KEYS = PTR_NEW(/A) ; KEYS is an array of strings
    SELF.VALUES = PTR_NEW(/A) ; VALUES is an array of pointers
    RETURN, 1
END
    

PRO CrabKeyValue::setKey, KeyName=KeyName, KeyValue=KeyValue, KeyMatched=KeyMatched, FOLD_CASE=FOLD_CASE
    IF N_ELEMENTS(KeyName) NE 1 OR N_ELEMENTS(KeyValue) EQ 0 THEN RETURN
    KeyNameList = (*SELF.KEYS)
    FOR i=0,N_ELEMENTS(KeyNameList)-1 DO BEGIN
        IF STRMATCH(KeyNameList[i],KeyName,FOLD_CASE=FOLD_CASE) THEN BEGIN
            (*SELF.VALUES)[i] = PTR_NEW(KeyValue)
            KeyMatched = i
            RETURN
        ENDIF
    ENDFOR
    (*SELF.KEYS) = [(*SELF.KEYS),KeyName]
    (*SELF.VALUES) = [(*SELF.VALUES),PTR_NEW(KeyValue,/A)]
END


PRO CrabKeyValue::setKeyValueAsAnArrayItem, KeyName=KeyName, KeyValue=KeyValue, ArrayItemId=ArrayItemId, ArrayLength=ArrayLength, $
                                            KeyMatched=KeyMatched, FOLD_CASE=FOLD_CASE
    ; this assumes each key value as an array
    IF N_ELEMENTS(KeyName) NE 1 OR N_ELEMENTS(KeyValue) EQ 0 OR N_ELEMENTS(ArrayItemId) NE 1 OR N_ELEMENTS(ArrayLength) NE 1 THEN RETURN
    KeyNameList = (*SELF.KEYS)
    FOR i=0,N_ELEMENTS(KeyNameList)-1 DO BEGIN
        IF STRMATCH(KeyNameList[i],KeyName,FOLD_CASE=FOLD_CASE) THEN BEGIN
            NewKeyValue = *(*SELF.VALUES)[i] ; this should be an array
            NewKeyValue[ArrayItemId] = KeyValue
            *(*SELF.VALUES)[i] = NewKeyValue
            KeyMatched = i
            RETURN
        ENDIF
    ENDFOR
    NewKeyValue = REPLICATE(0.0D,ArrayLength)
    NewKeyValue[ArrayItemId] = DOUBLE(KeyValue)
    (*SELF.KEYS) = [(*SELF.KEYS),KeyName]
    (*SELF.VALUES) = [(*SELF.VALUES),PTR_NEW(NewKeyValue,/A)]
END


FUNCTION CrabKeyValue::getKey, Index
    IF N_ELEMENTS(Index) NE 1 THEN RETURN, !NULL
    RETURN, (*SELF.KEYS)[Index]
END


FUNCTION CrabKeyValue::getKeyValue, KeyName=KeyName, KeyMatched=KeyMatched
    IF N_ELEMENTS(KeyName) NE 1 THEN RETURN, !NULL
    KeyNameList = (*SELF.KEYS)
    FOR i=0,N_ELEMENTS(KeyNameList)-1 DO BEGIN
        IF STRMATCH(KeyNameList[i],KeyName,FOLD_CASE=FOLD_CASE) THEN BEGIN
            KeyValue = *(*SELF.VALUES)[i]
            KeyMatched = i
            RETURN, KeyValue
        ENDIF
    ENDFOR
    RETURN, !NULL
END


FUNCTION CrabKeyValue::getKeyValueAsAnArrayItem, KeyName=KeyName, ArrayItemId=ArrayItemId, $
                                                 KeyMatched=KeyMatched, FOLD_CASE=FOLD_CASE
    IF N_ELEMENTS(KeyName) NE 1 OR N_ELEMENTS(ArrayItemId) NE 1 THEN RETURN, !NULL
    KeyNameList = (*SELF.KEYS)
    FOR i=0,N_ELEMENTS(KeyNameList)-1 DO BEGIN
        IF STRMATCH(KeyNameList[i],KeyName,FOLD_CASE=FOLD_CASE) THEN BEGIN
            KeyValue = *(*SELF.VALUES)[i]
            KeyMatched = i
            RETURN, KeyValue[ArrayItemId]
        ENDIF
    ENDFOR
    RETURN, !NULL
END


FUNCTION CrabKeyValue::getKeyNumber
    RETURN, N_ELEMENTS(*SELF.KEYS)
END


FUNCTION CrabKeyValue::getKeys
    RETURN, (*SELF.KEYS)
END


FUNCTION CrabKeyValue::getValues
    RETURN, (*SELF.VALUES)
END


PRO CrabKeyValue::CLEANUP
    PTR_FREE, SELF.KEYS
    FOR i=0,N_ELEMENTS(*SELF.VALUES)-1 DO BEGIN
        PTR_FREE, (*SELF.VALUES)[i]
    ENDFOR
    RETURN
END


PRO CrabKeyValue__DEFINE
    VOID = { CrabKeyValue, KEYS:PTR_NEW(), VALUES:PTR_NEW() }
    RETURN
END