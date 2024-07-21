using System.Net;
using System.Text.Json;
using IhmLlamaMvc.Application.Exceptions;
using IhmLlamaMvc.Mvc.Constants;
using IhmLlamaMvc.Mvc.Contracts;
using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Mvc.Middleware;

/// <summary>
/// Represents the exception handler middleware.
/// </summary>
internal class CustomExceptionHandlerMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<CustomExceptionHandlerMiddleware> _logger;
    private readonly IWebHostEnvironment _webHostEnvironment;


    /// <summary>
    /// Initializes a new instance of the <see cref="CustomExceptionHandlerMiddleware"/> class.
    /// </summary>
    /// <param name="next">The delegate pointing to the next middleware in the chain.</param>
    /// <param name="logger">The logger.</param>
    public CustomExceptionHandlerMiddleware(
        RequestDelegate next, 
        IWebHostEnvironment webHostEnvironment,
        ILogger<CustomExceptionHandlerMiddleware> logger)
    {
        _next = next;
        _webHostEnvironment = webHostEnvironment;
        _logger = logger;
    }

    /// <summary>
    /// Invokes the exception handler middleware with the specified <see cref="HttpContext"/>.
    /// </summary>
    /// <param name="httpContext">The HTTP httpContext.</param>
    /// <returns>The task that can be awaited by the next middleware.</returns>
    public async Task Invoke(HttpContext httpContext)
    {
        try
        {
            await _next(httpContext);
        }
        catch (Exception ex)
        {
            if (ex is ValidationException exception)
            {
               string errorsDetailsToLog= BuildValidationErrorDetailsToLog(
                    exception, httpContext, _webHostEnvironment.EnvironmentName);

                _logger.LogError(ex, errorsDetailsToLog);
            }
            else
            {
                const string newLine = "\r\n";
                var msg = $"{newLine}{ex.Message.ToUpper()} {newLine}";

                _logger.LogError(ex,
                    "{newLine}[Environnement : {environmentName}], " +
                    "une erreur s'est produite : {msg}",
                newLine, _webHostEnvironment.EnvironmentName, msg);
            }

            await HandleExceptionAsync(httpContext, ex);
        }
    }

    /// <summary>
    /// Handles the specified <see cref="Exception"/> for the specified <see cref="HttpContext"/>.
    /// </summary>
    /// <param name="httpContext">The HTTP httpContext.</param>
    /// <param name="exception">The exception.</param>
    /// <returns>The HTTP response that is modified based on the exception.</returns>
    private static async Task HandleExceptionAsync(HttpContext httpContext, Exception exception)
    {
        (HttpStatusCode httpStatusCode, IReadOnlyCollection<Error> errors) = 
            GetHttpStatusCodeAndErrors(exception);

        httpContext.Response.ContentType = "application/json";

        httpContext.Response.StatusCode = (int)httpStatusCode;

        var serializerOptions = new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        };

        string response = JsonSerializer.Serialize(
            new ApiErrorResponse(errors), serializerOptions);

        await httpContext.Response.WriteAsync(response);
    }

    /// <summary>
    /// Extracts the HTTP status code and a collection of errors based on the specified exception.
    /// </summary>
    /// <param name="exception">The exception.</param>
    /// <returns>The HTTP status code and a collection of errors based on the specified exception.</returns>
    private static (HttpStatusCode HttpStatusCode, IReadOnlyCollection<Error> Errors)
        GetHttpStatusCodeAndErrors(Exception exception) =>
        exception switch
        {
            ValidationException validationException => (HttpStatusCode.BadRequest, validationException.Errors),
            Exception anException => (HttpStatusCode.BadRequest,
                new[]
                {
                    new Error("Exception levée", $"{anException.Message}")
                }),
            _ => (HttpStatusCode.InternalServerError, new[] { Errors.ServerError })
        };

    private static string BuildValidationErrorDetailsToLog(
        ValidationException validationException,
        HttpContext httpContext, 
        string webHostEnvironment)
    {
        var validationErrorDetails = validationException.Errors
            .Distinct()
            .Select(failure =>
                new { Code = failure.Code, message = failure.Message });

        const string newLine = "\r\n";

        var errorDetailsToString = string.Join(newLine, validationErrorDetails);

        string requestDetails = GetRequestDetailsByHttpMethod(httpContext);
       

        var logDetails = $"{newLine}[Environnement : " +
                         $"{webHostEnvironment}], " +
                         $"{newLine}Requete HTTP : {newLine}{requestDetails}{newLine}" +
                         $"{newLine}une erreur s'est produite : " +
                         $"{newLine}{errorDetailsToString}{newLine}";

        return logDetails;
    }

    private static string GetRequestDetailsByHttpMethod(HttpContext httpContext)
    {
        const string newLine = "\r\n";
        string requestDetails = "";

        // requête soumise par un GET
        if (httpContext.Request.Method == HttpMethod.Get.ToString())
        {
            if (httpContext.Request.Query.Count > 0)
            {
                requestDetails = string.Join(newLine,
                    httpContext.Request.Query
                        .Select(h =>
                            new { key = h.Key, value = h.Value }));

                return requestDetails;
            }
        }

        // requête soumise par un POST
        if (httpContext.Request.Method == HttpMethod.Post.ToString())
        {
            if (httpContext.Request.Form.Count > 0)
            {
                requestDetails = string.Join(newLine,
                    httpContext.Request.Form
                        .Select(h =>
                            new { key = h.Key, value = h.Value }));

            }
        }

        return requestDetails;
    }
}