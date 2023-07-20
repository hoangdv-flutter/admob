#include "include/admob/admob_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "admob_plugin.h"

void AdmobPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  admob::AdmobPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
