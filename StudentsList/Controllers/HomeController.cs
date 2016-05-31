using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml;
using System.Xml.Serialization;
using StudentsList.Models;

namespace StudentsList.Controllers
{
    public class HomeController : Controller
    {
        private Students _students;
               

        //
        // GET: /Home/
        public ActionResult Index()
        {
            return View(GetStudentsList());
        }

        [HttpPost]
        public ActionResult Sort(string studentName)
        {
            Students students= GetStudentsList();

            students.StudentsList = _students.StudentsList.Where(x => x.FullName.ToUpper().Contains(studentName.ToUpper())).ToList();

            return View("Index", students);
        }

        public Students GetStudentsList(string path=null)
        {
            _students = new Students();

            XmlSerializer serializer = new XmlSerializer(typeof(List<Student>), new XmlRootAttribute("StudentsList"));

            var fileName = Path.Combine(path== null? Server.MapPath("~/App_Data"):path, "StudentsList.xml");

            using (var myFileStream = new FileStream(fileName, FileMode.Open))
            {
                XmlReader reader = XmlReader.Create(myFileStream);

                _students.StudentsList = (List<Student>)serializer.Deserialize(reader);
            }

            return _students;
        }

	}
}