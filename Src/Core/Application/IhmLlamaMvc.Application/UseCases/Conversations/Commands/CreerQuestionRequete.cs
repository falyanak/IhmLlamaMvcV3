using MediatR;

namespace IhmLlamaMvc.Application.UseCases.Conversations.Commands
{
    public  class CreerQuestionRequete : IRequest<string>
    {
        public string Question { get; set; }
        public int ModeleId { get; set; }
    }
}
