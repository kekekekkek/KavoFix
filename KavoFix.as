bool bShowOnce = false;

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor("kek");
	g_Module.ScriptInfo.SetContactInfo("https://github.com/kekekekkek/KavoFix");
	
	g_Hooks.RegisterHook(Hooks::Player::ClientSay, @ClientSay);
	g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, @ClientPutInServer);
}

//--------------------------------------------------------------------------------
/* [+] https://github.com/wootguy/ChatColors#integration-with-other-plugins*/

void PlayerSay(CBaseEntity@ pEntity, ClientSayType cstSayType, string strMsg)
{
	/*If you want to send a msg to one or several players you need to use "MSG_ONE" or "MSG_ONE_UNRELIABLE" flag 
	instead "MSG_ALL" and edict_t of the player*/
	
	/*I tried to use "TeamID" and "Classify" from CBaseEntity and "team" from entvars_t to compare but nothing works.
	All these functions and variables contain the same values. Maybe im doing something wrong?*/
	
	NetworkMessage NetMsg(MSG_ALL, NetworkMessages::NetworkMessageType(74)); //SayText
	
	NetMsg.WriteByte(pEntity.entindex());
	NetMsg.WriteByte(2); //CLASS_PLAYER
	
	//This shit works only visual but you really need to use "say_team"?
	NetMsg.WriteString(((cstSayType == CLIENTSAY_SAYTEAM) ? "(TEAM) " : "") + pEntity.pev.netname + ": " + strMsg + "\n");
    NetMsg.End();
}
//--------------------------------------------------------------------------------

bool IsWhiteSpaceOrEmpty(string strText)
{
	int iLength = strText.Length();

	for (int i = 0; i < iLength; i++)
	{
		if (strText.opIndex(i) != ' ') //32
			return false;
	}
	
	return true;
}

bool IsASCII(string strText)
{
	int iLength = strText.Length();
	
	for (int i = 0; i < iLength; i++)
	{
		if (strText.opIndex(i) == ' ') //32
			continue;
	
		if (strText.opIndex(i) >= '\0' //0
			and strText.opIndex(i) <= '~') //126
				return true;
	}
	
	return false;
}

HookReturnCode ClientSay(SayParameters@ pSayParam)
{
	string strMsg = pSayParam.GetCommand();
	
	CBasePlayer@ pPlayer = pSayParam.GetPlayer();
	const CCommand@ cmdArgs = pSayParam.GetArguments();
	
	if (!bShowOnce)
	{
		array<string> strPlugins = g_PluginManager.GetPluginList();
		int iArraySize = strPlugins.length();
		
		for (int i = 0; i < iArraySize; i++)
		{
			string strPlugin = strPlugins[i].ToLowercase();
		
			if (strPlugin == "chatcolors")
			{
				g_Game.AlertMessage(at_warning, "There is no support with \"ChatColors\" plugin.\n");
				break;
			}
		}
		
		bShowOnce = true;
	}
	
	//Checks if the plugin exists
	if (cmdArgs.ArgC() == 1)
	{
		string strArg = cmdArgs.Arg(0).ToLowercase();
	
		if (strArg == "!askavofix")
		{
			g_EngineFuncs.ClientPrintf(pPlayer, print_console, "\"!askavofix\" was found on this server!\n");
			pSayParam.ShouldHide = true;
			
			return HOOK_HANDLED;
		}
	}

	if (!IsWhiteSpaceOrEmpty(strMsg) and !IsASCII(strMsg))
		PlayerSay(pPlayer, pSayParam.GetSayType(), strMsg);

	return HOOK_CONTINUE;
}

HookReturnCode ClientPutInServer(CBasePlayer@ pPlayer)
{
	g_EngineFuncs.ClientPrintf(pPlayer, print_console, "\"!askavofix\" was found on this server!\n");
	return HOOK_CONTINUE;
}