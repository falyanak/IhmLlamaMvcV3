namespace IhmLlamaMvc.Application.Services
{
    public partial class ChatIaService
    {
       
        public async Task<string> GetAnswer(string question)
        {
            return await _callIaModel.GetAnswer(question);
        }

    }
}
