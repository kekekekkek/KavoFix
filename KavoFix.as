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
	NetworkMessage NetMsg(MSG_ALL, NetworkMessages::NetworkMessageType(74));	
	NetMsg.WriteByte(pEntity.entindex());
	
	/*Всё равно не будет работать с "ChatColors", так как в нём есть проверка на ArgC(). 
	При написании русских символов скорее всего ArgC() возвращает 0 (не проверял).
	Только если Вы выполните команды по типу "say 123; say Привет", так как плагин меняет
	классификацию игрока и ожидает 0.5 секунд для её сброса. Единственный вариант - имзенение 
	самого плагина "ChatColors".*/
	
	NetMsg.WriteByte(pEntity.Classify());
	NetMsg.WriteString("" + pEntity.pev.netname + ": " + strMsg + "\n");
	
    NetMsg.End();
}

void PlayerSayTeam(CBaseEntity@ pEntity, string strMsg)
{
	for (int i = 0; i < g_Engine.maxClients + 1; i++)
	{
		edict_t@ pCurEdict = g_EngineFuncs.PEntityOfEntIndex(i);
		CBaseEntity@ pCurEntity = g_EntityFuncs.Instance(pCurEdict);
		
		if (pEntity.IRelationship(pCurEntity) == R_AL)
		{
			NetworkMessage NetMsg(MSG_ONE, NetworkMessages::NetworkMessageType(74), pCurEdict);
		
			NetMsg.WriteByte(pEntity.entindex());
			NetMsg.WriteByte(pEntity.Classify());
			NetMsg.WriteString("(TEAM) " + pEntity.pev.netname + ": " + strMsg + "\n");
			
			NetMsg.End();
		}
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
	for (uint i = 0; i < strText.Length(); i++)
	{
		if (strText.opIndex(i) != ' ')
			return false;
	}
	
	return true;
}

bool IsASCII(string strText)
{	
	for (uint i = 0; i < strText.Length(); i++)
	{
		if (strText.opIndex(i) == ' ')
			continue;
	
		if (strText.opIndex(i) >= '\0'
			and strText.opIndex(i) <= '~')
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
		string strConMsg = "";
	
		if (!IsSayTeam(pSayParam.GetSayType()))
		{
			strConMsg = ("" + pPlayer.pev.netname + ": " + strMsg + "\n");
			g_EngineFuncs.ClientPrintf(pPlayer, print_console, strConMsg);
			
			PlayerSay(pPlayer, strMsg);
		}
		else
		{
			strConMsg = ("(TEAM) " + pPlayer.pev.netname + ": " + strMsg + "\n");
			g_EngineFuncs.ClientPrintf(pPlayer, print_console, strConMsg);
		
			PlayerSayTeam(pPlayer, strMsg);
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode ClientPutInServer(CBasePlayer@ pPlayer)
{
	g_EngineFuncs.ClientPrintf(pPlayer, print_console, "\"!askavofix\" was found on this server!\n");
	return HOOK_CONTINUE;
}