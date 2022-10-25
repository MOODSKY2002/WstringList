type WSTRING_List_Type
   sCount  as ulong
   sLenght as ulong
   sList   as PVOID
end type

'创建一个宽字符数组指针(数组元素数量,每个元素字符宽长度)
function Create_WSTR_List(byval Count as ulong,byval Lenght as ulong) as PVOID   
   dim sList as WSTRING_List_Type ptr
   
   sList = CAllocate(sizeof(WSTRING_List_Type) + Count * (Lenght + 1) * sizeof(wstring),1)   
   sList->sCount  = Count
   sList->sLenght = Lenght
   sList->sList   = sList + sizeof(WSTRING_List_Type)
   return sList
end function

'查询元素地址
function WSTR_Check(wList as WSTRING_List_Type ptr,byval Index as ulong) as ulongint
   dim sAddr  as ULONGINT
   if Index < 0 or Index > wList->sCount - 1 then return -1  
   if Index > 0 then sAddr = PtrToPtr64(wList->sList) + Index * (wList->sLenght + 1) else sAddr = PtrToPtr64(wList->sList)
   return sAddr
end function

'设置一个元素内容
function WSTR_List_Set(wList as WSTRING_List_Type ptr,byval Index as ulong,byval sStringW as wstring ptr) as long
   dim sAddr  as ULONGINT = WSTR_Check(wList,Index)
   if sAddr = - 1 then return -1 else wcscpy Ptr64ToPtr(sAddr),sStringW
   function = Index
end function

'返回元素指针
function WSTR_List_Read(wList as WSTRING_List_Type ptr,byval Index as ulong) as wstring ptr
   dim sAddr  as ULONGINT = WSTR_Check(wList,Index)
   if sAddr = - 1 then return -1 else function = Ptr64ToPtr(sAddr)   
end function

'返回元素内容
function WSTR_List_Get(wList as WSTRING_List_Type ptr,byval Index as ulong,byval sStringW as wstring ptr) as long
   dim sAddr  as ULONGINT = WSTR_Check(wList,Index)
   if sAddr = - 1 then return -1 else wcscpy sStringW,Ptr64ToPtr(sAddr)   
   function = Index
end function
