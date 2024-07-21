using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using SiccrfAuthorization.Nuget.Config;
using SiccrfAuthorization.Nuget.Interfaces;
using SiccrfAuthorization.Nuget.Services;
using SiccrfAuthorization.RefApiProvider;

namespace IhmLlamaMvc.Authorization.Extensions;

/// <summary>
/// Extension de la classe services pour isoler la configuration SICCRF
/// </summary>
public static class ServiceCollectionExtensions
{
    public static void AddAuthorization(this IServiceCollection services, 
        IConfiguration configuration, Serilog.ILogger logger)
    {
        // Permet d'obtenir HttpContext par l'injection de dépendance, utilisé par SiccrfAuthorizationService.
        // SiccrfAuthorizationService récupère HttpContext de l'application afin de stocker et récupérer AgentPermissions de
        // l'agent connecté ou de l'agent testé dans la variable de Session (clé : "Siccrf.Authorization.Agent").
        // https://docs.microsoft.com/fr-fr/aspnet/core/fundamentals/http-context?view=aspnetcore-3.0
        services.TryAddSingleton<IHttpContextAccessor, HttpContextAccessor>();

        // On passe l'implémentation de ISiccrfAuthorizationService par l'injection des dépendances, en Scoped        
        services.TryAddScoped<ISiccrfAuthorizationService, SiccrfAuthorizationService>();

        // On injecte le provider d'authorization, ici l'api referentiel
        services.TryAddScoped<IAuthorizationProvider, RefApiProvider>();

        // Instancie la classe SiccrfAuthorizationSettings et la transmet par injection des dépendances    
        services.Configure<SiccrfAuthorizationSettings>(
            configuration.GetSection("ApplicationSettings").GetSection("SiccrfAuthorization"));
    }
}