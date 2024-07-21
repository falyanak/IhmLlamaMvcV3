namespace IhmLlamaMvc.Mvc.Constants;

public class Constantes
{
    // sections de fichier appsettings.json

    public const string applicationSettings = "ApplicationSettings";
    public const string siccrfAuthorization = "Appsettings:SiccrfAuthorization";
    public const string siccrfWebApiAccess = "Appsettings:SiccrfWebApiAccess";
    public const string schedulerSettings = "Appsettings:Scheduler";
    public const string siccrfSiccrfBarreAppliConfig = "SiccrfBarreAppliConfig";

    // droits
    public const string gererDataDGAL = "GererDataDGAL";
    public const string gererDataDGDDI = "GererDataDGDDI";
    public const string gererDataSCL = "GererDataSCL";
    public const string gererDataGeneral = "GererDataGeneral";
    public const string voirDataGeneral = "VoirDataGeneral";

    // clé de session Http
    public const string SessionKeyProfil = "_Profil";
    public const string SessionKeyIsAdminSiccrf = "_IsAdminSiccrf";
    public const string SessionKeyIsVisualisationNationale = "_IsVisualisationNationale";
    public const string SessionKeyEntite = "_Entite";
    public const string SessionKeyAgentPermissions = "_AgentPermissions";
    public const string SessionKeyDroitModification = "_DroitModification";
    public const string SessionKeyUtilisateurConnecte = "_UtilisateurConnecte";

    // chaines
    public const string prefixeCompteCcrf = "ccrf\\";

    // fichier d'aide
    public const string cheminFichierAide = "\\Documents\\Aide_profil_plus.pdf";

    // RefApi
    public static string MnemosRefApiGetMultiAff = "V2_PERMISSION_GETUNITES_MULTIAFFECTATION";
}