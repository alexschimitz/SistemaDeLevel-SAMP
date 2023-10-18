#include <a_samp>
#include <sscanf2>
#include <izcmd>

//Macros
#define   CallBack::%0(%1) 	   	forward %0(%1);\
							public %0(%1)

//Cores
#define COR_ERRO 			0xDF3A01FF

//Variaveis do jogador
enum pInfo
{
	pLevel,
	pEXP
};
new PlayerInfo[MAX_PLAYERS][pInfo];
//Variaveis do TextDraw
new Text:LevelTD[8];
new PlayerText:LevelTDP[MAX_PLAYERS][11];


//--Funções

//Quando o jogador upar de level
UpPlayerLevel(playerid)
{
    new level = PlayerInfo[playerid][pLevel];
    new exp = PlayerInfo[playerid][pEXP];
    new ProxXP = XpNecessario(playerid, level);
    if (exp >= ProxXP)
    {
        PlayerInfo[playerid][pLevel]++;
		SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
        UpPlayerLevel(playerid);
        // Dar recompensas ou executar ações específicas ao atingir um novo nível
        SendClientMessage(playerid, -1, "Voce ganhou +1 level. Level atual: %d XP: %d", PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pEXP]);
		if(GetPlayerScore(playerid) == 10)
		{
			//Alguma coisa aqui ao jogador conquistar algum level. Substitua 10 pelo level.
        }
    }
}
//Dar Experiencia ao jogador
DarXP(playerid, quant)
{
    if(PlayerInfo[playerid][pLevel] >= 8000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce alcancou o level maximo.");
    PlayerInfo[playerid][pEXP] += quant;
    new LevelStr[10]; format(LevelStr, sizeof(LevelStr), "+ %d", quant);
	PlayerTextDrawSetString(playerid, LevelTDP[playerid][10], LevelStr);
    UpPlayerLevel(playerid);
    return 1;
}
//Verificar o proximo XP a ser atingido com base no level do jogador.
XpNecessario(playerid, level)
{
    new XpNecessario = 0;
    for (new i = 1; i <= level; i++)
    { 
        if (level >= 1 && level <= 21) 
        {
             new LevelAte21[] = { 800, 1300, 1700, 2300, 3400, 3000, 3500, 3800, 4200, 4500, 4900, 5300, 5500, 6000, 6200, 6600, 6900, 7200, 7600, 7800, 8200 };
             XpNecessario += LevelAte21[level - 1];
        }
        else if (22 <= i && i <= 97)
            XpNecessario += 7521 + ((i - 22) * 300);
        else if (i >= 98)
            XpNecessario += 28500 + ((i - 98) * 50);
    }

    new LevelStr[35]; format(LevelStr, sizeof(LevelStr), "%d / %d", PlayerInfo[playerid][pEXP], XpNecessario);
	PlayerTextDrawSetString(playerid, LevelTDP[playerid][9], LevelStr);
    format(LevelStr, sizeof(LevelStr), "%d", PlayerInfo[playerid][pLevel]);
	PlayerTextDrawSetString(playerid, LevelTDP[playerid][0], LevelStr);
    format(LevelStr, sizeof(LevelStr), "%d", PlayerInfo[playerid][pLevel] + 1);
	PlayerTextDrawSetString(playerid, LevelTDP[playerid][1], LevelStr);

    SetTimerEx("LevelHide" , 8000 , false, "i" , playerid);
	for(new t; t < 8; t++){
		TextDrawShowForPlayer(playerid, LevelTD[t]); }
    for(new t; t < 11; t++) {
		PlayerTextDrawShow(playerid, LevelTDP[playerid][t]); }
    return XpNecessario;
}

//Comandos de testes
CMD:darxp(playerid, params[])
{
    new xp;
    if(sscanf(params, "d", xp)) return SendClientMessage(playerid, -1, "/darxp [xp]");
    DarXP(playerid, xp);
    return 1;
}
CMD:resetarlevel(playerid)
{
    PlayerInfo[playerid][pEXP] = 0;
    PlayerInfo[playerid][pLevel] = 0;
}

public OnGameModeInit()
{
    LevelTD[0] = TextDrawCreate(162.000000, 93.000000, "ld_bum:blkdot");
    TextDrawFont(LevelTD[0], 4);
    TextDrawLetterSize(LevelTD[0], 0.600000, 2.000000);
    TextDrawTextSize(LevelTD[0], 39.500000, 27.500000);
    TextDrawSetOutline(LevelTD[0], 1);
    TextDrawSetShadow(LevelTD[0], 0);
    TextDrawAlignment(LevelTD[0], 1);
    TextDrawColor(LevelTD[0], 778942719);
    TextDrawBackgroundColor(LevelTD[0], 255);
    TextDrawBoxColor(LevelTD[0], 50);
    TextDrawUseBox(LevelTD[0], 1);
    TextDrawSetProportional(LevelTD[0], 1);
    TextDrawSetSelectable(LevelTD[0], 0);

    LevelTD[1] = TextDrawCreate(163.000000, 94.000000, "ld_bum:blkdot");
    TextDrawFont(LevelTD[1], 4);
    TextDrawLetterSize(LevelTD[1], 0.600000, 2.000000);
    TextDrawTextSize(LevelTD[1], 37.000000, 24.500000);
    TextDrawSetOutline(LevelTD[1], 1);
    TextDrawSetShadow(LevelTD[1], 0);
    TextDrawAlignment(LevelTD[1], 1);
    TextDrawColor(LevelTD[1], 255);
    TextDrawBackgroundColor(LevelTD[1], 255);
    TextDrawBoxColor(LevelTD[1], 50);
    TextDrawUseBox(LevelTD[1], 1);
    TextDrawSetProportional(LevelTD[1], 1);
    TextDrawSetSelectable(LevelTD[1], 0);

    LevelTD[2] = TextDrawCreate(372.000000, 93.000000, "ld_bum:blkdot");
    TextDrawFont(LevelTD[2], 4);
    TextDrawLetterSize(LevelTD[2], 0.600000, 2.000000);
    TextDrawTextSize(LevelTD[2], 39.500000, 27.500000);
    TextDrawSetOutline(LevelTD[2], 1);
    TextDrawSetShadow(LevelTD[2], 0);
    TextDrawAlignment(LevelTD[2], 1);
    TextDrawColor(LevelTD[2], 778942719);
    TextDrawBackgroundColor(LevelTD[2], 255);
    TextDrawBoxColor(LevelTD[2], 50);
    TextDrawUseBox(LevelTD[2], 1);
    TextDrawSetProportional(LevelTD[2], 1);
    TextDrawSetSelectable(LevelTD[2], 0);

    LevelTD[3] = TextDrawCreate(373.000000, 94.000000, "ld_bum:blkdot");
    TextDrawFont(LevelTD[3], 4);
    TextDrawLetterSize(LevelTD[3], 0.600000, 2.000000);
    TextDrawTextSize(LevelTD[3], 37.000000, 24.500000);
    TextDrawSetOutline(LevelTD[3], 1);
    TextDrawSetShadow(LevelTD[3], 0);
    TextDrawAlignment(LevelTD[3], 1);
    TextDrawColor(LevelTD[3], 255);
    TextDrawBackgroundColor(LevelTD[3], 255);
    TextDrawBoxColor(LevelTD[3], 50);
    TextDrawUseBox(LevelTD[3], 1);
    TextDrawSetProportional(LevelTD[3], 1);
    TextDrawSetSelectable(LevelTD[3], 0);

    LevelTD[4] = TextDrawCreate(220.000000, 131.000000, "ld_pool:ball");
    TextDrawFont(LevelTD[4], 4);
    TextDrawLetterSize(LevelTD[4], 0.600000, 2.000000);
    TextDrawTextSize(LevelTD[4], 30.000000, 31.000000);
    TextDrawSetOutline(LevelTD[4], 0);
    TextDrawSetShadow(LevelTD[4], 0);
    TextDrawAlignment(LevelTD[4], 1);
    TextDrawColor(LevelTD[4], 762231039);
    TextDrawBackgroundColor(LevelTD[4], 255);
    TextDrawBoxColor(LevelTD[4], 50);
    TextDrawUseBox(LevelTD[4], 1);
    TextDrawSetProportional(LevelTD[4], 1);
    TextDrawSetSelectable(LevelTD[4], 0);

    LevelTD[5] = TextDrawCreate(255.000000, 135.000000, "ld_bum:blkdot");
    TextDrawFont(LevelTD[5], 4);
    TextDrawLetterSize(LevelTD[5], 0.600000, 2.000000);
    TextDrawTextSize(LevelTD[5], 92.000000, 24.500000);
    TextDrawSetOutline(LevelTD[5], 1);
    TextDrawSetShadow(LevelTD[5], 0);
    TextDrawAlignment(LevelTD[5], 1);
    TextDrawColor(LevelTD[5], 778942719);
    TextDrawBackgroundColor(LevelTD[5], 255);
    TextDrawBoxColor(LevelTD[5], 50);
    TextDrawUseBox(LevelTD[5], 1);
    TextDrawSetProportional(LevelTD[5], 1);
    TextDrawSetSelectable(LevelTD[5], 0);

    LevelTD[6] = TextDrawCreate(256.000000, 136.000000, "ld_bum:blkdot");
    TextDrawFont(LevelTD[6], 4);
    TextDrawLetterSize(LevelTD[6], 0.600000, 2.000000);
    TextDrawTextSize(LevelTD[6], 89.500000, 22.500000);
    TextDrawSetOutline(LevelTD[6], 1);
    TextDrawSetShadow(LevelTD[6], 0);
    TextDrawAlignment(LevelTD[6], 1);
    TextDrawColor(LevelTD[6], 255);
    TextDrawBackgroundColor(LevelTD[6], 255);
    TextDrawBoxColor(LevelTD[6], 50);
    TextDrawUseBox(LevelTD[6], 1);
    TextDrawSetProportional(LevelTD[6], 1);
    TextDrawSetSelectable(LevelTD[6], 0);

    LevelTD[7] = TextDrawCreate(236.000000, 130.000000, "RP");
    TextDrawFont(LevelTD[7], 2);
    TextDrawLetterSize(LevelTD[7], 0.370833, 3.099998);
    TextDrawTextSize(LevelTD[7], 400.000000, 17.000000);
    TextDrawSetOutline(LevelTD[7], 1);
    TextDrawSetShadow(LevelTD[7], 0);
    TextDrawAlignment(LevelTD[7], 2);
    TextDrawColor(LevelTD[7], -1);
    TextDrawBackgroundColor(LevelTD[7], 255);
    TextDrawBoxColor(LevelTD[7], 50);
    TextDrawUseBox(LevelTD[7], 0);
    TextDrawSetProportional(LevelTD[7], 1);
    TextDrawSetSelectable(LevelTD[7], 0);
    return 1;
}

public OnPlayerConnect(playerid)
{
    LevelTDP[playerid][0] = CreatePlayerTextDraw(playerid, 182.000000, 97.000000, "1");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][0], 2);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][0], 0.279166, 1.700000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][0], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][0], 2);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][0], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][0], 0);

    LevelTDP[playerid][1] = CreatePlayerTextDraw(playerid, 392.000000, 97.000000, "2");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][1], 2);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][1], 0.279166, 1.700000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][1], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][1], 2);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][1], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][1], 0);

    LevelTDP[playerid][2] = CreatePlayerTextDraw(playerid, 205.000000, 104.000000, "ld_bum:blkdot");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][2], 4);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][2], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][2], 17.000000, 4.500000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][2], 1);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][2], 778942719);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][2], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][2], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][2], 0);

    LevelTDP[playerid][3] = CreatePlayerTextDraw(playerid, 227.000000, 104.000000, "ld_bum:blkdot");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][3], 4);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][3], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][3], 17.000000, 4.500000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][3], 1);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][3], 778942719);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][3], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][3], 0);

    LevelTDP[playerid][4] = CreatePlayerTextDraw(playerid, 250.000000, 104.000000, "ld_bum:blkdot");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][4], 4);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][4], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][4], 17.000000, 4.500000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][4], 1);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][4], 778942719);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][4], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][4], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][4], 0);

    LevelTDP[playerid][5] = CreatePlayerTextDraw(playerid, 274.000000, 104.000000, "ld_bum:blkdot");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][5], 4);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][5], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][5], 17.000000, 4.500000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][5], 1);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][5], 778942719);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][5], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][5], 0);

    LevelTDP[playerid][6] = CreatePlayerTextDraw(playerid, 298.000000, 104.000000, "ld_bum:blkdot");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][6], 4);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][6], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][6], 17.000000, 4.500000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][6], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][6], 1);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][6], 778942719);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][6], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][6], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][6], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][6], 0);

    LevelTDP[playerid][7] = CreatePlayerTextDraw(playerid, 321.000000, 104.000000, "ld_bum:blkdot");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][7], 4);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][7], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][7], 17.000000, 4.500000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][7], 1);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][7], 778942719);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][7], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][7], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][7], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][7], 0);

    LevelTDP[playerid][8] = CreatePlayerTextDraw(playerid, 345.000000, 104.000000, "ld_bum:blkdot");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][8], 4);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][8], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][8], 17.000000, 4.500000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][8], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][8], 1);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][8], 778942719);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][8], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][8], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][8], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][8], 0);

    LevelTDP[playerid][9] = CreatePlayerTextDraw(playerid, 286.000000, 113.000000, "0/800");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][9], 1);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][9], 0.191666, 1.150000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][9], 500.000000, 100.000000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][9], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][9], 2);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][9], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][9], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][9], 0);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][9], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][9], 0);

    LevelTDP[playerid][10] = CreatePlayerTextDraw(playerid, 292.000000, 133.000000, "+20000");
    PlayerTextDrawFont(playerid, LevelTDP[playerid][10], 2);
    PlayerTextDrawLetterSize(playerid, LevelTDP[playerid][10], 0.445833, 2.650000);
    PlayerTextDrawTextSize(playerid, LevelTDP[playerid][10], 500.000000, 100.000000);
    PlayerTextDrawSetOutline(playerid, LevelTDP[playerid][10], 0);
    PlayerTextDrawSetShadow(playerid, LevelTDP[playerid][10], 0);
    PlayerTextDrawAlignment(playerid, LevelTDP[playerid][10], 2);
    PlayerTextDrawColor(playerid, LevelTDP[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, LevelTDP[playerid][10], 255);
    PlayerTextDrawBoxColor(playerid, LevelTDP[playerid][10], 50);
    PlayerTextDrawUseBox(playerid, LevelTDP[playerid][10], 0);
    PlayerTextDrawSetProportional(playerid, LevelTDP[playerid][10], 1);
    PlayerTextDrawSetSelectable(playerid, LevelTDP[playerid][10], 0);
    return 1;
}