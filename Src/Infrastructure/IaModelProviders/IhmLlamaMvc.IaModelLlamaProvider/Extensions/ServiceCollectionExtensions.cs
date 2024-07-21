using System.Globalization;
using IhmLlamaMvc.Application.Interfaces;
using IhmLlamaMvc.IaModelLlamaProvider.Constants;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace IhmLlamaMvc.IaModelLlamaProvider.Extensions;

/// <summary>
/// Extension de la classe services pour isoler la configuration SICCRF
/// </summary>
public static class ServiceCollectionExtensions
{
    public static void AddModelIaProvidersInfrastructure(this IServiceCollection services,
        IConfiguration configuration, Serilog.ILogger logger)
    {
        services.TryAddScoped<ICallIaModel, SemanticKernelService>();
    }


}