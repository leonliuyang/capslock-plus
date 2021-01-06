; AutoHotkey版 谷歌翻译
; 用法：选中要翻译的文字，按两次Ctrl+C
; 热键：Ctrl+C, Ctrl+C
;--------------------------------------------------
;#NoEnv
 
 
; DoublePress() ; Simulate double press
; {
;    static pressed1 = 0
;    if pressed1 and A_TimeSincePriorHotkey <= 500
;    {
;       pressed1 = 0
;       ;Translate("en","ru") ; from English to Russian
;       keyword=%Clipboard%
;       ToolTip % GoogleTranslate(keyword)
;    }
;    else
;       pressed1 = 1
   
; }
 
; ~^C:: DoublePress()
 
 
; ~LButton:: ; Remove tooltip left click
; ToolTip
; return



global GoogleTransEdit,googleTransEditHwnd,googleTransGuiHwnd, GoogleNativeString

return 

setGoogleTransGuiActive:
WinActivate, ahk_id %googleTransGuiHwnd%
return

 ggTranslate(ss)
 {

googletransStart:
    ;  if(StrLen(ss) >= 2000)
    ;  {
    ;      MsgBox, , , 文本过长，请重新选择。, 1
    ;      return 
    ;  }
	ss:=RegExReplace(ss, "\s", " ") ;把所有空白符换成空格，因为如果有回车符的话，json转换时会出错
	
	;~ global 
	
	GoogleNativeString:=Trim(ss)

;MsgBox, %GoogleNativeString%

;responseStr = % GoogleTranslate(GoogleNativeString)
;msgbox , %responseStr%

;return

googleTransGui:
;~ WinClose, 谷歌翻译
MsgBoxStr:=GoogleNativeString?lang_google_translating:""

DetectHiddenWindows, On ;可以检测到隐藏窗口
WinGet, ifGuiExistButHide, Count, ahk_id %googleTransGuiHwnd%
if(ifGuiExistButHide)
{
	ControlSetText, , %MsgBoxStr%, ahk_id %googleTransEditHwnd%
	ControlFocus, , ahk_id %googleTransEditHwnd%
	WinShow, ahk_id %googleTransGuiHwnd%
}
else ;IfWinNotExist,  ahk_id %googleTransGuiHwnd% ;谷歌翻译
{
	;MsgBox, 0
	
	Gui, new, +HwndgoogleTransGuiHwnd , %lang_google_name%
	Gui, +AlwaysOnTop -Border +Caption -Disabled -LastFound -MaximizeBox -OwnDialogs -Resize +SysMenu -Theme -ToolWindow
	Gui, Font, s10 w400, Microsoft YaHei UI ;设置字体
	Gui, Font, s10 w400, 微软雅黑
	gui, Add, Button, x-40 y-40 Default, OK  
	
	Gui, Add, Edit, x-2 y0 w504 h405 vTransEdit HwndgoogleTransEditHwnd -WantReturn -VScroll , %MsgBoxStr%
	Gui, Color, ffffff, fefefe
	Gui, +LastFound
	WinSet, TransColor, ffffff 210
	Gui, Show, Center w500 h402, %lang_google_name%
	ControlFocus, , ahk_id %googleTransEditHwnd%
	SetTimer, setGoogleTransActive, 50
}
;~ DetectHiddenWindows, On ;可以检测到隐藏窗口
if(GoogleNativeString) ;如果传入的字符串非空则翻译
{
	;MsgBox, %GoogleNativeString%
	SetTimer, googleApi, -1
	return
}

Return

googleApi:
;MsgBox, 11
MsgBoxStr := GoogleNativeString
MsgBoxStr:= % MsgBoxStr . "`r`n`r`n" . lang_google_trans . "`r`n"

responseStr = % GoogleTranslate(GoogleNativeString)
MsgBoxStr:= % MsgBoxStr . responseStr
;MsgBox, %MsgBoxStr%

;~ MsgBox, % MsgBoxStr
setGoogleTransText:
ControlSetText, , %MsgBoxStr%, ahk_id %googleTransEditHwnd%
ControlFocus, , ahk_id %googleTransEditHwnd%
SetTimer, setGoogleTransActive, 50
return 
;================拼MsgBox显示的内容

GoogleButtonOK:
Gui, Submit, NoHide

GoogleTransEdit:=RegExReplace(GoogleTransEdit, "\s", " ") ;把所有空白符换成空格，因为如果有回车符的话，json转换时会出错
GoogleNativeString:=Trim(GoogleTransEdit)
;~ goto, googleApi
goto, googleTransGui

return

}

;确保激活
setGoogleTransActive:
IfWinExist, ahk_id %googleTransGuiHwnd%
{
    SetTimer, ,Off
    WinActivate, ahk_id %googleTransGuiHwnd%
}
return
 
GoogleTranslate(str, from := "auto", to :=0)  {
   static JS := CreateScriptObj(), _ := JS.( GetJScript() ) := JS.("delete ActiveXObject; delete GetObject;")
   if(!to)				; If no "to" parameter was passed
      to := GetISOLanguageCode()	; Assign the system (OS) language to "to"

   if(from = to)			; If the "from" and "to" parameters are the same
      Return str			; Abort translation and return the original string
   json := SendRequest(JS, str, to, from, proxy := "")
   ;return json
   ;msgbox , %json%
   oJSON := JS.("(" . json . ")")
 
   if !IsObject(oJSON[1])  {
      Loop % oJSON[0].length
         trans .= oJSON[0][A_Index - 1][0]
   }
   else  {
      MainTransText := oJSON[0][0][0]
      Loop % oJSON[1].length  {
         trans .= "`n+"
         obj := oJSON[1][A_Index-1][1]
         Loop % obj.length  {
            txt := obj[A_Index - 1]
            trans .= (MainTransText = txt ? "" : "`n" txt)
         }
      }
   }
   if !IsObject(oJSON[1])
      MainTransText := trans := Trim(trans, ",+`n ")
   else
      trans := MainTransText . "`n+`n" . Trim(trans, ",+`n ")
 
   from := oJSON[2]
   trans := Trim(trans, ",+`n ")
   Return trans
}

return 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
; Take a 4-digit language code or (if no parameter) the current language code and return the corresponding 2-digit ISO code
GetISOLanguageCode(lang := 0) {
   LanguageCodeArray := { 0436: "af" ; Afrikaans
			, 041c: "sq" ; Albanian
			, 0401: "ar" ; Arabic_Saudi_Arabia
			, 0801: "ar" ; Arabic_Iraq
			, 0c01: "ar" ; Arabic_Egypt
			, 1001: "ar" ; Arabic_Libya
			, 1401: "ar" ; Arabic_Algeria
			, 1801: "ar" ; Arabic_Morocco
			, 1c01: "ar" ; Arabic_Tunisia
			, 2001: "ar" ; Arabic_Oman
			, 2401: "ar" ; Arabic_Yemen
			, 2801: "ar" ; Arabic_Syria
			, 2c01: "ar" ; Arabic_Jordan
			, 3001: "ar" ; Arabic_Lebanon
			, 3401: "ar" ; Arabic_Kuwait
			, 3801: "ar" ; Arabic_UAE
			, 3c01: "ar" ; Arabic_Bahrain
			, 042c: "az" ; Azeri_Latin
			, 082c: "az" ; Azeri_Cyrillic
			, 042d: "eu" ; Basque
			, 0423: "be" ; Belarusian
			, 0402: "bg" ; Bulgarian
			, 0403: "ca" ; Catalan
			, 0404: "zh-CN" ; Chinese_Taiwan
			, 0804: "zh-CN" ; Chinese_PRC
			, 0c04: "zh-CN" ; Chinese_Hong_Kong
			, 1004: "zh-CN" ; Chinese_Singapore
			, 1404: "zh-CN" ; Chinese_Macau
			, 041a: "hr" ; Croatian
			, 0405: "cs" ; Czech
			, 0406: "da" ; Danish
			, 0413: "nl" ; Dutch_Standard
			, 0813: "nl" ; Dutch_Belgian
			, 0409: "en" ; English_United_States
			, 0809: "en" ; English_United_Kingdom
			, 0c09: "en" ; English_Australian
			, 1009: "en" ; English_Canadian
			, 1409: "en" ; English_New_Zealand
			, 1809: "en" ; English_Irish
			, 1c09: "en" ; English_South_Africa
			, 2009: "en" ; English_Jamaica
			, 2409: "en" ; English_Caribbean
			, 2809: "en" ; English_Belize
			, 2c09: "en" ; English_Trinidad
			, 3009: "en" ; English_Zimbabwe
			, 3409: "en" ; English_Philippines
			, 0425: "et" ; Estonian
			, 040b: "fi" ; Finnish
			, 040c: "fr" ; French_Standard
			, 080c: "fr" ; French_Belgian
			, 0c0c: "fr" ; French_Canadian
			, 100c: "fr" ; French_Swiss
			, 140c: "fr" ; French_Luxembourg
			, 180c: "fr" ; French_Monaco
			, 0437: "ka" ; Georgian
			, 0407: "de" ; German_Standard
			, 0807: "de" ; German_Swiss
			, 0c07: "de" ; German_Austrian
			, 1007: "de" ; German_Luxembourg
			, 1407: "de" ; German_Liechtenstein
			, 0408: "el" ; Greek
			, 040d: "iw" ; Hebrew
			, 0439: "hi" ; Hindi
			, 040e: "hu" ; Hungarian
			, 040f: "is" ; Icelandic
			, 0421: "id" ; Indonesian
			, 0410: "it" ; Italian_Standard
			, 0810: "it" ; Italian_Swiss
			, 0411: "ja" ; Japanese
			, 0412: "ko" ; Korean
			, 0426: "lv" ; Latvian
			, 0427: "lt" ; Lithuanian
			, 042f: "mk" ; Macedonian
			, 043e: "ms" ; Malay_Malaysia
			, 083e: "ms" ; Malay_Brunei_Darussalam
			, 0414: "no" ; Norwegian_Bokmal
			, 0814: "no" ; Norwegian_Nynorsk
			, 0415: "pl" ; Polish
			, 0416: "pt" ; Portuguese_Brazilian
			, 0816: "pt" ; Portuguese_Standard
			, 0418: "ro" ; Romanian
			, 0419: "ru" ; Russian
			, 081a: "sr" ; Serbian_Latin
			, 0c1a: "sr" ; Serbian_Cyrillic
			, 041b: "sk" ; Slovak
			, 0424: "sl" ; Slovenian
			, 040a: "es" ; Spanish_Traditional_Sort
			, 080a: "es" ; Spanish_Mexican
			, 0c0a: "es" ; Spanish_Modern_Sort
			, 100a: "es" ; Spanish_Guatemala
			, 140a: "es" ; Spanish_Costa_Rica
			, 180a: "es" ; Spanish_Panama
			, 1c0a: "es" ; Spanish_Dominican_Republic
			, 200a: "es" ; Spanish_Venezuela
			, 240a: "es" ; Spanish_Colombia
			, 280a: "es" ; Spanish_Peru
			, 2c0a: "es" ; Spanish_Argentina
			, 300a: "es" ; Spanish_Ecuador
			, 340a: "es" ; Spanish_Chile
			, 380a: "es" ; Spanish_Uruguay
			, 3c0a: "es" ; Spanish_Paraguay
			, 400a: "es" ; Spanish_Bolivia
			, 440a: "es" ; Spanish_El_Salvador
			, 480a: "es" ; Spanish_Honduras
			, 4c0a: "es" ; Spanish_Nicaragua
			, 500a: "es" ; Spanish_Puerto_Rico
			, 0441: "sw" ; Swahili
			, 041d: "sv" ; Swedish
			, 081d: "sv" ; Swedish_Finland
			, 0449: "ta" ; Tamil
			, 041e: "th" ; Thai
			, 041f: "tr" ; Turkish
			, 0422: "uk" ; Ukrainian
			, 0420: "ur" ; Urdu
			, 042a: "vi"} ; Vietnamese
   If(lang)
     Return LanguageCodeArray[lang]
   Else Return LanguageCodeArray[A_Language]
}
SendRequest(JS, str, tl, sl, proxy) {
   ComObjError(false)
   http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   ( proxy && http.SetProxy(2, proxy) )
   ;~ http.open( "POST", "https://translate.google.com/translate_a/single?client=webapp&sl="
   http.open( "POST", "https://translate.google.cn/translate_a/single?client=webapp&sl="
      . sl . "&tl=" . tl . "&hl=" . tl
      . "&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=0&ssel=0&tsel=0&pc=1&kc=1"
      . "&tk=" . JS.("tk").(str), 1 )
 
   http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
   http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
   http.send("q=" . URIEncode(str))
   http.WaitForResponse(-1)
   Return http.responsetext
}
 
URIEncode(str, encoding := "UTF-8")  {
   VarSetCapacity(var, StrPut(str, encoding))
   StrPut(str, &var, encoding)
 
   While code := NumGet(Var, A_Index - 1, "UChar")  {
      bool := (code > 0x7F || code < 0x30 || code = 0x3D)
      UrlStr .= bool ? "%" . Format("{:02X}", code) : Chr(code)
   }
   Return UrlStr
}
 
GetJScript()
{
   script =
   (
      var TKK = ((function() {
        var a = 561666268;
        var b = 1526272306;
        return 406398 + '.' + (a + b);
      })());
 
      function b(a, b) {
        for (var d = 0; d < b.length - 2; d += 3) {
            var c = b.charAt(d + 2),
                c = "a" <= c ? c.charCodeAt(0) - 87 : Number(c),
                c = "+" == b.charAt(d + 1) ? a >>> c : a << c;
            a = "+" == b.charAt(d) ? a + c & 4294967295 : a ^ c
        }
        return a
      }
 
      function tk(a) {
          for (var e = TKK.split("."), h = Number(e[0]) || 0, g = [], d = 0, f = 0; f < a.length; f++) {
              var c = a.charCodeAt(f);
              128 > c ? g[d++] = c : (2048 > c ? g[d++] = c >> 6 | 192 : (55296 == (c & 64512) && f + 1 < a.length && 56320 == (a.charCodeAt(f + 1) & 64512) ?
              (c = 65536 + ((c & 1023) << 10) + (a.charCodeAt(++f) & 1023), g[d++] = c >> 18 | 240,
              g[d++] = c >> 12 & 63 | 128) : g[d++] = c >> 12 | 224, g[d++] = c >> 6 & 63 | 128), g[d++] = c & 63 | 128)
          }
          a = h;
          for (d = 0; d < g.length; d++) a += g[d], a = b(a, "+-a^+6");
          a = b(a, "+-3^+b+-f");
          a ^= Number(e[1]) || 0;
          0 > a && (a = (a & 2147483647) + 2147483648);
          a `%= 1E6;
          return a.toString() + "." + (a ^ h)
      }
   )
   Return script
}
 
CreateScriptObj() {
   static doc
   doc := ComObjCreate("htmlfile")
   doc.write("<meta http-equiv='X-UA-Compatible' content='IE=9'>")
   Return ObjBindMethod(doc.parentWindow, "eval")
}