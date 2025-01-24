Bicep is Azure's native taal voor het deployen van resources naar Azure. 
Het is gebaseerd op Azure Resource Manager(ARM) templates, maar versimpeld en uitgebreid. 
Er is gekozen om de drie kritieke services waar het Azure-gedeelte van het netwerk op draait middels Bicep uit te rollen omdat er binnen Bicep uitgebreide mogelijkheden zijn om resources te configureren en snel uit te rollen en Bicep een best-practice is voor het gebruik van automation binnen Azure.

Er is gekozen om de volgende resources middels Bicep uit te rollen:

1. Virtual Network: de bouwsteen van het Azure gedeelte van het netwerk. Mocht het netwerk om wat voor reden dan ook niet meer functioneren of er een aanpassing gedaan moet worden aan IP-ranges / subnets dan kan dit snel d.m.v. Bicep gedaan worden.
2. Virtual Network Gateway: de verbinding tussen het on-premises netwerk en het Azure netwerk. Een van de bouwstenen van de gehele Ijsselstreek-infrastructuur en dus heel belangrijk dat deze altijd operationeel is. Mocht deze niet meer werken kan deze d.m.v. Bicep snel weer opgezet worden.
3. AD's: Het AD is het hart van de Services van Ijsselstreek-university. Mocht deze plat gaan of corupt raken is het erg belangrijk dat deze snel weer opgezet kan worden en z.s.m. weer geconfigureerd kan worden. Daarom is er ook gekozen om direct vanuit Bicep een PowerShell script uit te voeren dat Het AD inregeld. 
4. Exchange: in de oorspronkelijke configuratie van het netwerk was er een losse Exchange server. Met de Ijsselstreek-fusie is deze Exchange server overgegaan naar het AD. Dit script wordt dus niet meer gebruikt, maar is wel ontwikkeld. 

P.S. de nieuwste Bicep code is te vinden in de Testing Branch.
