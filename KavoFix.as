bool bShowOnce = false;

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor("kek");
	g_Module.ScriptInfo.SetContactInfo("https://github.com/kekekekkek/KavoFix");
	
	g_Hooks.RegisterHook(Hooks::Player::ClientSay, @ClientSay);
	g_Hooks.RegisterHook(Hooks::Player::ClientPutInServer, @ClientPutInServer);
}

void PlayerSay(CBaseEntity@ pEntity, string strMsg)
{
	NetworkMessage NetMsg(MSG_ALL, NetworkMessages::NetworkMessageType(74)); //SayText
	
	NetMsg.WriteByte(pEntity.entindex());
	NetMsg.WriteByte(2); //CLASS_PLAYER
	NetMsg.WriteString("" + pEntity.pev.netname + ": " + strMsg + "\n");
	
    NetMsg.End();
}

void PlayerSayTeam(CBaseEntity@ pEntity, string strMsg)
{
	for (int i = 1; i < g_Engine.maxClients; i++)
	{
		edict_t@ pCurEdict = g_EngineFuncs.PEntityOfEntIndex(i);
		CBaseEntity@ pCurEntity = g_EntityFuncs.Instance(pCurEdict);
		
		//Check if the player in your team (ally)
		NetworkMessage NetMsg(MSG_ONE, NetworkMessages::NetworkMessageType(74), ((pEntity.IRelationship(pCurEntity) == R_AL) ? pCurEdict : pEntity.edict())); //SayText
		
		NetMsg.WriteByte(pEntity.entindex());
		NetMsg.WriteByte(2); //CLASS_PLAYER
		NetMsg.WriteString("(TEAM) " + pEntity.pev.netname + ": " + strMsg + "\n");
		
		NetMsg.End();
	}
}

bool IsSayTeam(ClientSayType cstSayType)
{
	if (cstSayType == CLIENTSAY_SAYTEAM)
		return true;
		
	return false;
}

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
	{
		if (!IsSayTeam(pSayParam.GetSayType()))
			PlayerSay(pPlayer, strMsg);
		else
			PlayerSayTeam(pPlayer, strMsg);
	}

	return HOOK_CONTINUE;
}

HookReturnCode ClientPutInServer(CBasePlayer@ pPlayer)
{
	g_EngineFuncs.ClientPrintf(pPlayer, print_console, "\"!askavofix\" was found on this server!\n");
	return HOOK_CONTINUE;
}