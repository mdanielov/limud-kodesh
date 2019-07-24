using Microsoft.VisualStudio.TestTools.UnitTesting;
using HebrewTexts.DAL.Persistence.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HebrewTexts.DAL.Persistence.Repositories.Tests
{
    [TestClass()]
    public class GroupsRepositoryTests
    {
        [TestMethod()]
        public void FindRootByGroupIDTest()
        {

            var groupIDfortest = 55;
            var repo = new GroupsRepository();
            var result = repo.FindRootByGroupID(groupID: groupIDfortest);

        }
    }
}