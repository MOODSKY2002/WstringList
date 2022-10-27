'保持BASIC习惯数组序号从0开始
type WSTRING_List_Type
   Count        as ulong           '数组维度
   WSTR_Lenght  as ulong           '每个元素宽字符长度
   WSTR_Step    as ulong           '指针偏移   
   WSTR_List    as PVOID           '数组指针
end type

'创建一个宽字符数组指针(数组元素数量,每个元素字符宽长度)
function WSTR_List_Create(byval Count as ulong,byval Lenght as ulong) as WSTRING_List_Type
   dim wList as WSTRING_List_Type

   wList.Count       = Count
   wList.WSTR_Lenght = Lenght + 1 '+CHR(0)
   wList.WSTR_Step   = wList.WSTR_Lenght * sizeof(wstring)
   wList.WSTR_List   = CAllocate(Count,wList.WSTR_Step)
   return wList
end function

'释放数组
sub WSTR_List_Close(wList as WSTRING_List_Type)
   wList.Count       = 0
   wList.WSTR_Lenght = 0
   Deallocate wList.WSTR_List
end sub

'数组扩容
sub WSTR_List_Redim(wList as WSTRING_List_Type,byval Count as ulong)
   dim sCount as ulong = wList.Count
   dim sList  as PVOID = CAllocate(Count,wList.WSTR_Step)

   memcpy sList,wList.WSTR_List,sCount * wList.WSTR_Step      
   Deallocate wList.WSTR_List         
   wList.WSTR_List = sList
   wList.Count     = Count
end sub

'返回元素指针
function WSTR_List_GetPtr(wList as WSTRING_List_Type,byval Index as ulong) as wstring ptr
   if Index < 0 or Index > wList.Count - 1 then EXIT FUNCTION 

   DIM sStringW as wstring ptr     
   function = wList.WSTR_List + (Index * wList.WSTR_Step)
end function

'设置一个元素内容
function WSTR_List_Set(wList as WSTRING_List_Type,byval Index as ulong,byval sStringW as wstring ptr) as long
   DIM mStringW as wstring ptr = WSTR_List_GetPtr(wList,Index)
   if mStringW = NULL then return -1 else wcscpy mStringW,sStringW
   function = Index
end function

'返回元素内容
function WSTR_List_Get(wList as WSTRING_List_Type,byval Index as ulong,byval sStringW as wstring ptr) as long
   DIM mStringW as wstring ptr = WSTR_List_GetPtr(wList,Index)
   if mStringW = NULL then return -1 else wcscpy sStringW,mStringW
   function = Index
end function

'搜索元素内容(Lenght=0全内容匹配,=5仅前5个字符匹配即认为匹配,Ignorecase是否忽略大小写开关,成功返回元素序号,失败返回-1)
function WSTR_List_Find(wList as WSTRING_List_Type,byval sStringW as wstring ptr,byval Lenght as long,byval IgnoreCase as boolean) as long   
   dim wTmp as wstring ptr
   dim ii   as Long   
     
   for ii = 0 to wList.Count - 1
      wTmp = wList.WSTR_List + (ii * wList.WSTR_Step)
      if Lenght then         
         if Ignorecase = true then 
            if _wcsnicmp(sStringW,wTmp,Lenght) = 0 then return ii
         else
            if wcsncmp(sStringW,wTmp,Lenght) = 0 then return ii         
         end if            
      else
         if Ignorecase = true then 
            if _wcsicmp(sStringW,wTmp) = 0 then return ii
         else
            if wcscmp(sStringW,wTmp) = 0 then return ii    
         end if
      end if
   next
   return -1
end function
                        
'操作示例  
 Common Shared MyWSTRList as WSTRING_List_Type
Function Form1_Button1_Click( ByRef sender As wfxButton, ByRef e As EventArgs ) As LRESULT
   dim wTmp1 as wstring * 512
   dim wTmp2 as wstring ptr
   dim ii as long
   
    MyWSTRList = WSTR_List_Create(1,16)
    WSTR_List_Redim MyWSTRList,10
    for ii = 9 to 0 step -1
      wTmp1 =  ii & "aaaaaaaaaaaaaa" & ii
      WSTR_List_Set MyWSTRList,ii,@wTmp1
    next

    for ii = 0 to 9
      'WSTR_List_Get MyWSTRList,ii,@wTmp1 
      'messagebox 0,wtmp1,"",0
      
      wTmp2 = WSTR_List_GetPtr(MyWSTRList,ii)
      messagebox 0,*wtmp2,"",0
    next

   Function = 0
End Function
