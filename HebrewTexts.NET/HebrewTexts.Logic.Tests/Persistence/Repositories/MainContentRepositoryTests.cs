using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.Logic.Persistence.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.Logic.Persistence.Repositories.Tests
{
    [TestClass()]
    public class MainContentRepositoryTests
    {
        [TestMethod()]
        public void GetByGroupIDTest()
        {
            var repo = new MainContentRepository(AppUser.GetForTests());
            var result =repo.GetByGroupID(2);
        }
    }
}