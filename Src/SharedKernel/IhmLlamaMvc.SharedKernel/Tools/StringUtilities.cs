using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace IhmLlamaMvc.SharedKernel.Tools;

public static class StringUtilities
{
    // suppression des caractères accentués en leur équivalents non accentués
    public static string RemoveAccents(this string text)
    {
        StringBuilder sbReturn = new StringBuilder();
        var arrayText = text.Normalize(NormalizationForm.FormD).ToCharArray();
        foreach (char letter in arrayText)
        {
            if (CharUnicodeInfo.GetUnicodeCategory(letter) != UnicodeCategory.NonSpacingMark)
                sbReturn.Append(letter);
        }
        return sbReturn.ToString();
    }

    public static string Capitalize(string str)
    {
        if (string.IsNullOrEmpty(str))
        {
            return  "";
        }

        // remplacer 2 blancs et plus consécutifs par 1 seul
        str = Regex.Replace(str, " {2,}", " ");

        string? result = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(str.Trim().ToLower());

        return result;

    }
    public static string ToCamelCase(string? str, bool withSpace = false)
    {
        if (string.IsNullOrEmpty(str))
        {
            return "";
        }

        string result = Capitalize(str);

        result = result.Replace(" ", string.Empty);

        return result;
    }

    public static string UpperCase(string? str)
    {
        if (string.IsNullOrEmpty(str))
        {
            return "";
        }

        // remplacer 2 blancs et plus consécutifs par 1 seul
        str = Regex.Replace(str, " {2,}", " ");
        return str.Trim().ToUpper();
    }

    public static string? LowerCase(string str)
    {
        if (string.IsNullOrEmpty(str))
        {
            return null;
        }

        // remplacer 2 blancs et plus consécutifs par 1 seul
        str = Regex.Replace(str, " {2,}", " ");
        return str.Trim().ToLower();
    }

    // formatage numéros téléphone français
    public static string FormatPhoneNumber(string str)
    {
        Regex telephoneRegExp =
            new Regex(@"^(\+33\s?|0)([1-9]{1})(\s?[0-9]{2}){4}$",
                options: RegexOptions.None, TimeSpan.FromSeconds(2));

        // remplacer 2 blancs et plus consécutifs par 1 seul
        str = Regex.Replace(str, " {2,}", " ");

        if (telephoneRegExp.IsMatch(str) && str.Substring(0, 3) == "+33")
        {
            str = string.Format("{0:+## # ## ## ## ##}", Convert.ToDouble(str));
        }
        else
        if (telephoneRegExp.IsMatch(str) && str.First() == '0')
        {
            str = string.Format("{0:0# ## ## ## ##}", Convert.ToDouble(str));
        }

        return str;
    }

    public static string? GenerateCompteActiveDirectoryFromValidNomAndPrenom(
        string nom, string prenom, string suffixe = "ccrf")
    {
        // suprression des caractères accentués
        string _prenom = prenom.RemoveAccents();
        string _nom = nom.RemoveAccents();

        // suppression des espaces , extraction de la 1ère lettre du prénom, mise en minuscules
        _prenom = _prenom.Trim().Substring(0, 1).ToLower();

        // et remplacer le - et ' par une chaine vide et
        // supprimer les espaces éventuels dans le nom,
        // mise en minuscules
        _nom = _nom.Trim()
            .Replace("-", string.Empty)
            .Replace("'", string.Empty)
            .Replace(" ", string.Empty).ToLower();

        // ne prendre que les 7 premières lettres du nom sinon tout et ajouter "-ccrf"
        string compteAd = _prenom + (_nom.Length < 7 ? _nom : _nom.Substring(0, 7)) + "-" + suffixe;

        return compteAd.ToLower();
    }

    /// <summary>
    /// construire un modèle pour trouver les variantes de login Windows utilisées
    /// en supprimant les éventuels chiffres positionnés avsnt le suffixe (-ccrf)
    /// exemple : mmoreau1-ccrf donne mmoreau%-ccrf ou mmore3-ccrf donne mmore%-ccrf
    /// </summary>
    /// <param name="compteAd"></param>
    /// <returns></returns>
    public static string BuildDuplicatedActiveDirectoryAccountSearchString(
        string compteAd, string suffixe)
    {
        // obtenir la position du - dans le suffixe
        int startSuffixPosition = compteAd.IndexOf(suffixe, 0);

        // extraire la sous chaine sans le suffixe : mmoreau-ccrf => mmoreau
        string compteAdWithoutSuffix = compteAd.Substring(0, startSuffixPosition);

        // détecte la 1ère position d'un chiffre dans le compte Ad, mmoreau3 => 7 
        //        var firstDigitPosition = compteAdWithoutSuffix.IndexOfAny("0123456789".ToCharArray());

        // supprimer les éventuels nombres en fin de login : mmoreau2 => mmoreau
        string compteAdWithoutSuffixAndNumbers = Regex.Replace(compteAdWithoutSuffix, @"\d+$", "");

        // placer le joker % de Transact-SQL
        // règle : si login AD contient 8 caractères avant le suffixe, longueur maximale, on substitue le % au 8ème caractère
        // sinon on ajoute le % au login AD
        // voir projet de Tests classe CompteAdTest.cs
        string compteAdDuplicatedModel = compteAdWithoutSuffixAndNumbers.Length == 8
            ? compteAdWithoutSuffixAndNumbers.Substring(0, 7) + "%" + suffixe
            : compteAdWithoutSuffixAndNumbers + "%" + suffixe;

        return compteAdDuplicatedModel;
    }

    public static string? GetLoginWindowsFromHttpUserIdentityName(string? httpIdentityName)
    {
        if (httpIdentityName is null)
        {
            throw new ArgumentException($"La chaine est vide dans {nameof(StringUtilities)}.{nameof(GetLoginWindowsFromHttpUserIdentityName)}");
        }

        var loginWindows = httpIdentityName.Contains("\\")
            ? httpIdentityName.Split("\\")[1]
            : httpIdentityName;

        return loginWindows;
    }

    /// <summary>
    /// convertir la propriété Active Directory memberOf de la classe User
    /// en une liste de groupes séparés par une virgule
    /// </summary>
    /// <param name="memberOf"></param>
    /// <returns></returns>
    public static string? MemberOfActiveDirectoryGroupListToString(string? memberOf)
    {
        if (memberOf is null || memberOf.ToArray().Length == 0)
        {
            return "";
        }

        string[] groupList = memberOf.Split("CN=").Skip(1).ToArray()
            .Select(g => g.Split(","))
            .Select(f => f.First()).ToArray();

        //var grp= groupList.Select(g=>g.Split(","))
        //    .Select(f=>f.First()).ToArray();

        var groupListToString = string.Join(", ", groupList);

        return groupListToString;
    }

    public static string GetIdentityFromMailAddress(string mailAddress)
    {
        return mailAddress.Split('@')[0];

    }

    public static string GetOrganizationUnitFromDistinguishedName(
        string distinguishedName)
    {
        var cn = distinguishedName.Split(",")[0];

        var ouPath = distinguishedName.Substring(cn.Length + 1);

        return ouPath;
    }

    public static string GetCommonNameFromDistinguishedName(string distinguishedName)
    {
        var cn = distinguishedName.Split(",")[0];

        return cn;
    }

    public static string GetNameFromCommonName(string distinguishedName)
    {
        var name = distinguishedName.Split("CN=")[1];

        return name;
    }

    /// <summary>
    /// Attention pour se conformer à la sémantique de FluentValidation
    /// le retour sera false si le modèle est validé
    /// </summary>
    /// <param name="chaine"></param>
    /// <returns></returns>
    public static bool ContientPlusieursCaracteresConsecutifsIdentiques(string chaine)
    {
        var modele = @"([a-zA-Z\s'\-])(\1)(\1+)";

        Regex regExp = new Regex(modele, RegexOptions.IgnoreCase, TimeSpan.FromSeconds(2));

        return !regExp.IsMatch(chaine);
    }

    //private static bool RegexUtiliseGlobalTimeOutToPreventDenyOfservice()
    //{
    //    var regexDefaultMatchTimeout =
    //        AppDomain.CurrentDomain.GetData("REGEX_DEFAULT_MATCH_TIMEOUT") as TimeSpan?;

    //    if (regexDefaultMatchTimeout == null)
    //    {
    //        throw new ArgumentException(
    //            "MatchTimeout is not set from REGEX_DEFAULT_MATCH_TIMEOUT.");
    //    }

    //    var regexMatchTimeout = new Regex("abc").MatchTimeout;

    //    if (regexDefaultMatchTimeout != regexMatchTimeout)
    //    {
    //        throw new ArgumentException(
    //            "MatchTimeout is not set from REGEX_DEFAULT_MATCH_TIMEOUT.");
    //    }

    //    return true;
    //}

}