<h1>.Net application deployment</h1>
<p>The simple .Net application with build (msbuild based) and deploy (msdeploy based) scripts. Used as a part of DevOps Labs to give students hands-on experience deploying .Net applications. For simplicity deployment is conducted within the same VM; parameterization, skip rules, DB deployments etc. are omitted.
<p>Preconditions: Windows 2012R2 with installed IIS
<p>1)	Download and install git for windows<br> https://git-scm.com/download/win
<p>2)	Clone repository to folder c:\studentlist <br>
<code>git clone https://github.com/DevOpsTests/StudentsList.git</code>
<p>3)	Install MS Web Deploy 3.5 with all features<br> https://www.microsoft.com/en-us/download/details.aspx?id=39277
<p>4)	Install WebApplication.targets. Quick way: <p>
Download file http://desia.tk/targets.zip and unzip content to <code>"C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v11.0\"</code><br>
Create folder “v11.0” if not exist.
<p>5)	Build project using build.cmd ( c:\studentlist )
<p>6)	Create user account for deployment (For example user “deploy”) and add to Users, Administrators and MSDepSvcUsers groups (create group if not exist).
<p>7)	Install/configure IIS<br>
<p>a.	Server manager -> Manage -> Add roles and features -> Server Roles -> Web Server(IIS). Do not forget to install components from “Application development”<br>
<p>b.	Enable Management Service:<br>
Open “Internet Information Services Manager” -> “Management Service”, check “Enable remote connections”. Then “Apply” and “Start”.
<p>c.	Create Web application with name “Students”
<p>d.	Grant permission to user “Network service” for the next:
<li>Read permission to %windir%\system32\inetsrv\config 
<li>Modify permission to %windir%\system32\inetsrv\config\applicationHost.config. 
<p>e. Check application pool for “Students”. Ensure that “.Net CLR Version” is set to “v4.0” and “Managed Pipeline Mode” is “Integrated”
<p>8)	Proceed with deployment using deploy.cmd
<li>a. Edit deploy.cmd Add USERNAME and PASSWORD variables with walues from step 6.
<p>9)	Browse Web application “Students” by IE, Chrome etc., and ensure that application is working.