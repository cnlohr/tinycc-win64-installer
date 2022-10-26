!include nsDialogs.nsh
!include LogicLib.nsh
!include "tcc-installer-header.nsh"
!include "EnvVarUpdate.nsh"

!define DEFAULT_DIR $PROGRAMFILES\${TCC_VERSION}

Name ${TCC_VERSION}

ShowInstDetails show

Var box1
Var box2
Var box3
Var Dialog
Var hwnd
Var CheckboxPathsSystem
Var CheckboxPathsUser

page license
page custom nsDialogsPage
page directory
page instfiles

LicenseData INSTALLED_README.txt
Outfile  ${INSTALLER}
InstallDir ${DEFAULT_DIR}

Section
SetOutPath "$INSTDIR"
File /r InstallData\*
WriteUninstaller $INSTDIR\uninstaller.exe
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${TCC_VERSION}" "DisplayName" "${TCC_VERSION} - The TinyCC C Compiler"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${TCC_VERSION}" "UninstallString" "$\"$INSTDIR\uninstaller.exe$\""
${If} $CheckboxPathsSystem == "yes"
    ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR"
    DetailPrint  "set SYSTEM path"
${EndIf}
${If} $CheckboxPathsUser == "yes"
    ${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR"
    DetailPrint  "set USER path"
${EndIf}
SectionEnd

Section "Uninstall"
Delete $INSTDIR\uninstaller.exe
RMDir /r $INSTDIR
DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${TCC_VERSION}"
${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"
${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR"
SectionEnd

Function nsDialogsPage
    nsDialogs::Create 1018
    Pop $Dialog
    ${If} $Dialog == error
        Abort
    ${EndIf}
    ${NSD_CreateCheckbox} 0 30u 100% 10u "&Add tcc to your SYSTEM path. (Recommended)"
    Pop $box1
    strcpy $CheckboxPathsSystem "yes"
    ${NSD_AddStyle} $box1 ${WS_GROUP}
    ${NSD_OnClick} $box1 RadioClick
    ${NSD_SetState} $box1 ${BST_CHECKED}
    ${NSD_CreateCheckbox} 0 60u 100% 10u "&Add tcc to your USER path."
    Pop $box2
    ${NSD_OnClick} $box2 RadioClick
    ${NSD_CreateCheckbox} 0 90u 100% 10u "&Do not add tcc to your PATH."
    Pop $box3
    ${NSD_OnClick} $box3 RadioClick
    nsDialogs::Show
FunctionEnd
Function RadioClick
    Pop $hwnd
    ${If} $hwnd == $box1
        strcpy $CheckboxPathsSystem "yes"
        strcpy $CheckboxPathsUser "no"
        ${NSD_SetState} $box1 ${BST_CHECKED}
        ${NSD_SetState} $box2 ${BST_UNCHECKED}
        ${NSD_SetState} $box3 ${BST_UNCHECKED}
    ${ElseIf} $hwnd == $box2
        strcpy $CheckboxPathsUser "yes"
        strcpy $CheckboxPathsSystem "no"
        ${NSD_SetState} $box1 ${BST_UNCHECKED}
        ${NSD_SetState} $box2 ${BST_CHECKED}
        ${NSD_SetState} $box3 ${BST_UNCHECKED}
    ${ElseIf} $hwnd == $box3
        strcpy $CheckboxPathsUser "no"
        strcpy $CheckboxPathsSystem "no"
        ${NSD_SetState} $box1 ${BST_UNCHECKED}
        ${NSD_SetState} $box2 ${BST_UNCHECKED}
        ${NSD_SetState} $box3 ${BST_CHECKED}
    ${EndIf}
FunctionEnd
