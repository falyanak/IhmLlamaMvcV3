using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using SiccrfWebApiAccess.Nuget.Configuration;
using SiccrfWebApiAccess.Nuget.Constants;
using SiccrfWebApiAccess.Nuget.Interfaces;
using SiccrfWebApiAccess.Nuget.Services;

namespace IhmLlamaMvc.WebApi.Extensions;

/// <summary>
/// Extension de la classe services pour isoler la configuration SICCRF
/// </summary>
public static class ServiceCollectionExtensions
{
    public static void AddWebApiAccessServices(this IServiceCollection services, 
        IConfiguration configuration, Serilog.ILogger logger)
    {
        // injecter WebApiAccessService
        services.TryAddScoped<IWebApiAccessService, WebApiAccessService>();

        // Associer la configuration du cache définie dans Appsettings à la classe CacheConfiguration
        services.Configure<WebApiAccessSettings>(configuration.GetSection(Constantes.SiccrfWebApiAccess));
        // Configurer HttpClient pour l'appel à la Web Api de l'EFSA pour obtenir au format Json la codification d'un produit
        AddWebApiAccessHttpClient(services, configuration, logger);
    }

    // pour les requêtes au serveur interne SICCRF, ne pas utiliser le proxy
    private static void AddWebApiAccessHttpClient(IServiceCollection services, 
        IConfiguration configuration, Serilog.ILogger logger)
    {
        // Injecter IHttpClient vers la WebApi

        var retryCount = Convert.ToInt32(configuration[Constantes.NumberOfHttpRetries]);

        services.AddHttpClient("SiccrfWebApiAccess", httpClient =>
            {
                httpClient.BaseAddress = new Uri(configuration.GetValue<string>(Constantes.ReferentielApiBaseUrl));
            })
            .ConfigurePrimaryHttpMessageHandler(() =>
            {
                return new HttpClientHandler()
                {
                    UseDefaultCredentials = true
                };
            });
    }


}