unit ComDefine;

interface

uses
  SvcMgr, SysUtils, Messages, Windows, Classes, DateUtils, Forms, StdCtrls,
  ComCtrls, ScktComp, ShellAPI, WinSvc, Registry, Dialogs;

const
  {ͼ��}
  WM_MIDASICON = WM_USER + 2;
  {��ʼ��}
  UI_INITIALIZE = WM_USER + 4;
  {������ʾ}
  WM_ShowWinSysServer = WM_USER + 6;
  {ϵͳ��״̬�仯����ͬ�ڷ�����������ֹͣ״̬�仯}
  WM_DMServerState = WM_USER + 8;
  {ͼ��仯״̬}
  WM_DMServerICONState = WM_USER + 10;
  {��־��¼�仯}
  WM_LogChange = WM_USER + 12;
  {�����б仯�������ݼ�ⴰ�巢��}
  WM_DataMonitorChange = WM_USER + 14;

  {ϵͳ����״̬}
  CO_DMServerState_Run = 1;
  {ϵͳֹͣ״̬}
  CO_DMServerState_Stop = 0;
  {ϵͳ��������������}
  CO_DMServerState_Runing = 101;
  {ϵͳ����ֹͣ������}
  CO_DMServerState_Stoping = 100;
  {����δ֪״̬}
  CO_DMServerState_Wait = 1000;
  KEY_USERSYSSERVER = '\Software\UserSysServer\';
  KEY_IE = 'SOFTWARE\Microsoft\Internet Explorer';

const
//****************************** ÿ����Ŀ����Ҫ�޸ĵ����� ********************
  {�������ʾ����}
  _SysServerDisplayName = 'BP_SYSServer';
  {��������}
  _SysServerName = 'BP_SYSServer';
  {�����˵��}
  _SysServerReadme = 'Ѫѹ������';
  {ϵͳ��������}
  _SysServerMainTitle = 'Ѫѹ������'; //ϵͳ������
  {ϵͳ�ĸ�����}
  _SysServerSubtitle = ''; //������
  {ϵͳ��Ψһ��ʶ,������ֹͬһ�������������}
  _SysServerMutexID = 'F779BF46-7D20-4CBE-98FE-9492EBBDC561'; //ϵͳΨһ��ʶ

resourcestring
  SServiceOnly = 'ϵͳֻ��������  NT 3.51 �汾���ϡ�';
  SErrClose = 'ȷ��Ҫ�˳�ϵͳ��';
  SAlreadyRunning = '��ǰ�����Ѿ����С�';


implementation

end.