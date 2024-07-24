namespace IhmLlamaMvc.Mvc.ViewModels;

public class AProposDe
{
    // !!! Ce paramètre est passé dans _Layout.cshtml !!!
    public string? AdoBuildUrl { get; set; }

    // !!! Ce paramètre est passé dans _Layout.cshtml !!!
    public string? ApplicationVersion { get; set; }

    // !!! Ce paramètre est passé dans _Layout.cshtml !!!
    public string? BuildId { get; set; }

    // !!! Ce paramètre est passé dans _Layout.cshtml !!!
    public string? ReleaseDate { get; set; }

    // Cette valeur est donnée par UAParser
    public string? VersionSysteme { get; set; }

    // Cette valeur est donnée par UAParser
    public string? NomVersionNavigateur { get; set; }

    // Cette valeur est donnée par Siccrf.Authorization.Agent
    public string? CompteAd { get; set; }

    // Cette valeur est donnée par Siccrf.Authorization.Agent
    public string? Profils { get; set; }

    //  Cette valeur est donnée par Siccrf.Authorization.Agent
    public string? Droits { get; set; }

    // Cette valeur est donnée par Siccrf.Authorization.Agent
    public string? Services { get; set; }

    // Cette valeur est donnée par Siccrf.Authorization.Agent
    public string? ServicePrincipal { get; set; }

    public string? Synthese { get; set;}

    public bool IsAuthenticated { get; set; }
    public string? servicePrincipal { get; set; }
}
