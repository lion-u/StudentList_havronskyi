using NUnit.Framework;
using StudentsList.Controllers;
using StudentsList.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace Tests
{
    public class HomeControllerTest
    {
        private HomeController _home;

        private string _path;

        [SetUp]
        public void SetUp()
        {
            _home = new HomeController();

            _path =  Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"../../../StudentsList/App_Data");
        }

        [Test]
        public void InitializationTest()
        {
            Students students = _home.GetStudentsList(_path);

            Assert.IsNotNull(students.StudentsList);
        }

        [Test]
        public void DataTest()
        {
            Students students = _home.GetStudentsList(_path);

            Assert.AreEqual(students.StudentsList[0].Age, 19);
            Assert.AreEqual(students.StudentsList[0].Address, "Lviv");
            Assert.AreEqual(students.StudentsList[0].Phone, "123456");
        }

        [Test]
        public void SortTest()
        {  
            Assert.That(() => _home.Sort("Kate"),
                Throws.TypeOf<NullReferenceException>());
        }

    }
}
