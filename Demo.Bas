'保持BASIC习惯数组序号从0开始
type WSTRING_List_Type
   Count        as ulong           '数组维度
   WSTR_Lenght  as ulong           '每个元素宽字符长度
   WSTR_List    as wstring ptr ptr '数组指针
end type

Common Shared  zzz as WSTRING_List_Type

'创建一个宽字符数组指针(数组元素数量,每个元素字符宽长度)
function WSTR_List_Create(byval Count as ulong,byval Lenght as ulong) as WSTRING_List_Type
   dim sList as WSTRING_List_Type

   sList.Count       = Count
   sList.WSTR_Lenght = Lenght + 1 '+CHR(0)
   sList.WSTR_List   = CAllocate(Count,sList.WSTR_Lenght * sizeof(wstring))
   return sList
end function

sub WSTR_List_Redim(wList as WSTRING_List_Type,byval Count as ulong)
   dim sCount as ulong = wList.Count
   dim sList  as wstring ptr ptr = CAllocate(Count,wList.WSTR_Lenght * sizeof(wstring))

   memcpy sList,wList.WSTR_List,sCount * wList.WSTR_Lenght * sizeof(wstring)      
   Deallocate wList.WSTR_List         
   wList.WSTR_List = sList
   wList.Count     = Count
end sub

'释放数组
sub WSTR_List_Close(wList as WSTRING_List_Type)
   wList.Count       = 0
   wList.WSTR_Lenght = 0
   Deallocate wList.WSTR_List
end sub

'设置一个元素内容
function WSTR_List_Set(wList as WSTRING_List_Type,byval Index as ulong,byval sStringW as wstring ptr) as long
   if Index < 0 or Index > wList.Count - 1 then EXIT FUNCTION
   wList.WSTR_List[Index] = sStringW
   function = Index
end function

'返回元素指针
function WSTR_List_GetPtr(wList as WSTRING_List_Type,byval Index as ulong) as wstring ptr
   if Index < 0 or Index > wList.Count - 1 then EXIT FUNCTION   
   return wList.WSTR_List[Index]
end function

'返回元素内容
function WSTR_List_Get(wList as WSTRING_List_Type,byval Index as ulong,byval sStringW as wstring ptr) as long
   if Index < 0 or Index > wList.Count - 1 then EXIT FUNCTION 
   wcscpy sStringW,wList.WSTR_List[Index] 
   function = Index
end function

'搜索元素内容(Lenght=0全内容匹配,=5仅前5个字符匹配即认为匹配,Ignorecase是否忽略大小写开关,成功返回元素序号,失败返回-1)
function WSTR_List_Find(wList as WSTRING_List_Type,byval sStringW as wstring ptr,byval Lenght as long,byval Ignorecase as boolean) as long   
   dim wTmp as wstring ptr
   dim ii   as Long   
    
   for ii = 0 to wList.Count - 1
      wTmp = wList.WSTR_List[ii]
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

'以下为使用示例
Function Form1_Button2_Click( ByRef sender As wfxButton, ByRef e As EventArgs ) As LRESULT
    zzz = WSTR_List_Create (5,16)   
    messagebox 0,"|" & zzz.WSTR_List,"",0
    WSTR_List_Set zzz,0, @wstr("1中中中中中中中中中中中中1")
    WSTR_List_Set zzz,1, @wstr("2AAAAAAAAAAAAAA2")
    WSTR_List_Set zzz,2, @wstr("3AAAAAAAAAAAAAA3")
    WSTR_List_Set zzz,3, @wstr("4AAAAAAAAAAAAAA4")
    WSTR_List_Set zzz,4, @wstr("5AAAAAAAAAAAAAA5")
    WSTR_List_Redim(zzz,10)
    messagebox 0,"|" & zzz.WSTR_List,"",0
    WSTR_List_Set zzz,5, @wstr("6AAAAAAAAAAAAAA6")
    WSTR_List_Set zzz,6, @wstr("7AAAAAAAAAAAAAA7")
    WSTR_List_Set zzz,7, @wstr("8AAAAAAAAAAAAAA8")
    WSTR_List_Set zzz,8, @wstr("9AAAAAAAAAAAAAA9")
    WSTR_List_Set zzz,9, @wstr("0AAAAAAAAAAAAAA0")

   Function = 0
End Function



Function Form1_Button3_Click( ByRef sender As wfxButton, ByRef e As EventArgs ) As LRESULT
   
   dim wTmp as wstring * 512
   dim wtmp1 as wstring ptr
   WSTR_List_Get zzz,0,@wTmp
messagebox 0,"|" & wtmp & "|","",0
WSTR_List_Get zzz,1,@wTmp
messagebox 0,"|" & wtmp & "|","",0
WSTR_List_Get zzz,2,@wTmp
messagebox 0,"|" & wtmp & "|","",0
WSTR_List_Get zzz,9,@wTmp
messagebox 0,"|" & wtmp & "|","",0
messagebox 0,"|" & WSTR_List_Find(zzz,@wstr("1中中"),3,TRUE) & "|","",0
   Function = 0
End Function
