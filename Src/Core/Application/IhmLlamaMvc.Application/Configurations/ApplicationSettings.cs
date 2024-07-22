namespace IhmLlamaMvc.Application.Configurations;

public class ApplicationSettings
{
    public string? AppCodeAppli { get; set; }
    public string? ReferentielApiBaseUrl { get; set; }
    public string? GetMnemoUrl { get; set; }

    public string? TitreAppli { get; set; }
    public string? CouleurAppli { get; set; }

    public string? LibsUrl { get; set; }
    public string? PortailUrl { get; set; }
    public string? ContactUrl { get; set; }
    public string? ImgAvatarAgentUrl { get; set; }

    public string? AnnuaireAgentUrl { get; set; }

    public string? ListeBlanche { get; set; }
    public string MailFrom { get; set; }
    public string EmailDeveloppeur { get; set; } = "";

    public string? Mode { get; set; }
    public List<string>? ConnectionString { get; set; }

    public string? MentionsLegales { get; set; }
    public string? ApplicationVersion { get; set; }
    public string? ReleaseDate { get; set; }
    public string? BuildId { get; set; }

    public string? AdoBuildUrl { get; set; }

    public string BalFonctionnelleDggddi { get; set; } = "";
    public string BalFonctionnelleDgal { get; set; } = "";
    public string BalFonctionnelleSiccrfCne { get; set; } = "";
    public string BalFonctionnelleSiccrfSql { get; set; } = "";

}