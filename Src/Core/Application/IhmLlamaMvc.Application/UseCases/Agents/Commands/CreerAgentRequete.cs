using IhmLlamaMvc.Domain.Entites.Agents;
using IhmLlamaMvc.SharedKernel.Primitives.Result;
using MediatR;

namespace IhmLlamaMvc.Application.UseCases.Agents.Commands
{
    public class CreerAgentRequete : IRequest<Result<Agent>>
    {
        public CreerAgentRequete(string nom, string prenom, string loginWindows)
        {
            Nom = nom;
            Prenom = prenom;
            LoginWindows = loginWindows;
        }
        public string Nom { get; set; }
        public string Prenom { get; set; }
        public string LoginWindows { get; set; }

    }
}

