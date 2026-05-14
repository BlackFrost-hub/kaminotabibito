#define YDWE_PRELOADSL_HEAD_MASK                         'YDWE'    
#define YDWE_PRELOADSL_CODE_INDEX_BEG(p)         (501*GetPlayerId(p))
#define YDWE_PRELOADSL_GET_RND_MASK()                GetRandomInt('0000', 'OOOO')    
#define YDWE_PRELOADSL_LIST_FILE(dir)                "save\\"+dir+"\\list.sav" 
#define YDWE_PRELOADSL_DATA_FILE(dir, file)    "save\\"+dir+"\\pre"+file+".sav"    

#define YDWE_PRELOADSL_GET_KEY(p)                        StringHash(GetPlayerName(p))

     
#include "YDWEStringHash.j"
#include "Util/YDWESync.j"

library YDWEPreloadSL initializer Init requires YDWEStringHash, YDWESync

globals
    ///
    /// ÿ�����ռ�õĿռ�[500*id, 500*(id-1))
    /// �±�Խ��û�н��м��,�ƺ�û�����Ҫ,˭Ҫ���ó���500...��ȥ����- -
    /// 
    private integer array Code
    private integer array CodeHI
    private integer array CodeLO
    boolean bj_lastLoadPreloadSLResult
endglobals        
 
#include "PreloadSL/YDWE_PreloadSL_Pre.j" 
#include "PreloadSL/YDWE_PreloadSL_Manager.j" 
#include "PreloadSL/YDWE_PreloadSL_Code.j" 

#if 0 
    ///    
    ///    һ���򵥵Ķ�浵�����ӿ� 
    ///        ��dirĿ¼�µ�list.sav�ļ�,��ȡ���е��ַ�����    
    ///        �������ڼ�¼���Ŀ¼�µĴ浵�ļ���,��ȻҪ����������;Ҳ�ǿ��Եġ� 
    /// 
    function YDWE_PreloadSL_SetFile takes player p, string dir, string value, integer n returns nothing
    function YDWE_PreloadSL_GetFile takes player p, string dir, integer n returns string
    ///    
    ///    ��ȡ�����ļ���code������
    ///    ͬһʱ���ڲ����һ�����ϵ���Ҷ�ȡ����,Load��������lock����֤��㡣����Load�������Ϸ��ء� 
    ///    ����false,��ʾ��ȡʧ�ܡ�ʧ��ʱ,code�����ڵ�ֵ����ò����š�ʧ�ܵ�ԭ�������    
    ///        1.�����Ŀ¼�����ļ���                                        
    ///        2. n��ֵ�ͱ���ʱ��һ��                                    
    ///        3.������ͱ���ʱ��һ��                                     
    ///        4.�浵���޸Ĺ���                                    
    ///
    function YDWE_PreloadSL_Load takes player p, string dir, string file, integer max_n returns boolean
    ///    
    ///    ����code���鵽�����ļ�    
    ///
    function YDWE_PreloadSL_Save takes player p, string dir, string file, integer max_n returns nothing 
    ///    
    ///    ��дcode�������ֵ 
    /// 
    function YDWE_PreloadSL_Set takes player p, string s, integer n, integer value returns nothing
    function YDWE_PreloadSL_Get takes player p, string s, integer n returns integer     
#endif
                                
private function Init takes nothing returns nothing
    local integer index = 0 
    loop
        exitwhen    index >= 16
        set udg_YDWE_PreloadSL_List[index] = "<null>"
        set index = index + 1
    endloop
endfunction 

endlibrary 
                 
#undef YDWE_PRELOADSL_HEAD_MASK
#undef YDWE_PRELOADSL_GET_RND_MASK
#undef YDWE_PRELOADSL_CODE_INDEX_BEG                    
#undef YDWE_PRELOADSL_LIST_FILE                        
#undef YDWE_PRELOADSL_LIST_FILE 

