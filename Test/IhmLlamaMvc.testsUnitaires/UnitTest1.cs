using IhmLlamaMvc.Domain.Entites.Agents;
using IhmLlamaMvc.Domain.Entites.Conversations;
using IhmLlamaMvc.Domain.Entites.IaModels;
using IhmLlamaMvc.Domain.Entites.Questions;
using IhmLlamaMvc.Domain.Entites.Reponses;
using System.Diagnostics;

namespace IhmLlamaMvc.testsUnitaires
{
    public class UnitTest1
    {
        // Attention, des tests dépendent de ces listes
        public List<Reponse> listeReponses { get; set; }=new List<Reponse>();
        public List<Question> listeQuestions { get; set; }= new List<Question>();
        public List<ModeleIA> listeModeles { get; set; } = new List<ModeleIA>();
        public List<Agent> listeAgents { get; set; } = new List<Agent>();

        /// <summary>
        /// constructeur appelé à cahque test
        /// </summary>
        public UnitTest1()
        {
            Debug.WriteLine("---> Constructeur appelé à chaque test");
   
            listeQuestions.Add(new("Quel est ton nom ?"));
            listeQuestions.Add(new("Quel est ton âge ?"));
            listeQuestions.Add(new("As-tu un frère ?"));

            listeReponses.Add(new("Legoat" ));
            listeReponses.Add(new("20"));
            listeReponses.Add(new("Oui"));

            listeModeles.Add(new ModeleIA("Llama", "http://localhost:11431", "3"));
            listeModeles.Add(new ModeleIA("ChatGpt", "http://localhost:11432", "4"));

            listeAgents.Add(new Agent("Zaber", "Mek", "mzaber-ccrf"));
            listeAgents.Add(new Agent("Avare", "Mot", "mavare-ccrf"));
        }

        [Fact]
        public void EstUneConversationValide()
        {
            //Arrange
            var conversation = new Conversation(
           "conversation1",
           DateTime.Now,
           listeModeles[0],
           listeAgents[0],
           listeQuestions[..2]);

            conversation.Questions[0].Reponse = listeReponses[0];
            conversation.Questions[1].Reponse = listeReponses[1];

            //Act
            var result = conversation.ModeleIA.Libelle.Equals("Llama");
            var nbQuestions = conversation.Questions.Count;
            var nbReponses = conversation.Questions.Select(q => q.Reponse).Count();

            //Assert
            Assert.True(result);
            Assert.Equal(2, nbQuestions);
            Assert.Equal(2, nbReponses);
        }

        [Fact]
        public void PourUneQuestionUneSeulereponseAssociée()
        {
            //Arrange
            var conversation = new Conversation(
                "conversation1",
                DateTime.Now,
                listeModeles[0],
                listeAgents[1],
                listeQuestions[..2]);

            conversation.Questions[0].Reponse = listeReponses[0];
            conversation.Questions[1].Reponse = listeReponses[2];

            //Act
            var result = conversation.ModeleIA.Libelle.Equals("Llama");
            var nbQuestions = conversation.Questions.Count;
            var nbReponses = conversation.Questions.Select(q => q.Reponse).Count();

            //Assert
            Assert.True(result);
            Assert.Equal(2, nbQuestions);
            Assert.Equal(2, nbReponses);
        }

    }


}
