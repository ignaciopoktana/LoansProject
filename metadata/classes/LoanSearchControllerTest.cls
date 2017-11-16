@isTest
public class LoanSearchControllerTest
{
     public testMethod static void TestCases()
    {
        /*List<User> usuarios = new LoanSearchController().getAllUsers();
        System.debug('Tamanio='+usuarios.size());
        system.assertEquals(usuarios.size(), 9);*/
        System.debug('init future users');
        // This code runs as the system user
            Profile prof  = [SELECT Id FROM Profile  WHERE Name='Librarian'];
        	UserRole RoleAdmin = [SELECT Id FROM UserRole WHERE Name='Librarian' limit 1];
            User userLib  = new User(
                                    Alias 				= 'LTest1', 
                                    Email				='LibrarianUser@TestOktana.io',
                                    EmailEncodingKey	='UTF-8', 
                                    LastName			='Testing', 
                                    LanguageLocaleKey	='en_US',
                                    LocaleSidKey		='en_US', 
                                    ProfileId 			= prof.Id,
                					UserRoleId 			= RoleAdmin.Id,
                                    TimeZoneSidKey		='America/Los_Angeles',
                                    UserName			='LibrarianAUser@TestOktana.io'
                                    ); 
            Insert userLib;
            
            
            // This code runs as the system user
            prof       = [SELECT Id FROM Profile  WHERE Name='Student'];
            String StudentRole = [SELECT Id FROM UserRole WHERE Name='Student' limit 1].id;
            User userC = new User(
                                    Alias 				='SaTest1', 
                                    Email				='StuaUser@TestOktana.io',
                                    EmailEncodingKey	='UTF-8',
                					FirstName			='StudentC',
                                    LastName			='Testing', 
                                    LanguageLocaleKey	='en_US',
                                    LocaleSidKey		='en_US', 
                                    ProfileId 			= prof.Id,
                					UserRoleId 			= StudentRole,
                                    TimeZoneSidKey		='America/Los_Angeles',
                                    UserName			='StudentCUser@TestOktana.io'
                                    ); 
            Insert UserC;
            
            User userD = new User(
                                    Alias 				='SBTest1', 
                                    Email				='StuBUser@TestOktana.io',
                                    EmailEncodingKey	='UTF-8',
                					FirstName			='StudentD',
                                    LastName			='Testing', 
                                    LanguageLocaleKey	='en_US',
                                    LocaleSidKey		='en_US', 
                                    ProfileId 			= prof.Id,
                					UserRoleId 			= StudentRole,
                                    TimeZoneSidKey		='America/Los_Angeles',
                                    UserName			='StudentDUser@TestOktana.io'
                                    ); 
            Insert UserD;
        
        
        System.runAs(userLib)
            {
                
                List<Book__c>      InsertBooks = new List<Book__c>();
                List<Book_Copy__c> BookCopies  = new List<Book_Copy__c>();
                Book__c newBook;
                for(integer i =0; i<5;i++)
                {
                    newBook = New Book__c();
                    newBook.Name = 'Dexter ' + i;
                    newBook.Author__c = 'Gendy Tartakovsky';
                    newBook.Description__c = 'Genius kid';
                    newBook.Publisher__c = 'Cartoon Network';
                    Insertbooks.add(newBook);
                }
                System.debug('InsertBooks size='+InsertBooks.size());
                insert InsertBooks;
                
                for(Book__c Book:InsertBooks)
                {
                    for(integer j = 0;j<2;j++)
                    {
                        Book_Copy__c newBookCopy = new Book_Copy__c();
                        newBookCopy.Book__c		 = Book.id;
                        newBookCopy.Active__c	 = True;
                        BookCopies.add(newBookCopy);
                    }
                }
                System.debug('BookCopies size='+BookCopies.size());
                insert BookCopies;
                
                
                        
                PageReference pageToTest = page.LoansHomePage; 
                
                string Testput = ApexPages.currentPage().getParameters().put('SearchUserBar ','Ignacio');
                Test.setCurrentPage(pageToTest);
                System.debug('Var Testput='+Testput);
                LoanSearchController TestController = new LoanSearchController();
                        
                        
                Test.startTest();
                try
                {            
                       
                       TestController.AllUsers		= null; 
					   TestController.LoansListSize	= 0;
                       //Non Existent Student
                       TestController.searchStudent = null;
                       TestController.searchUsers(); 
                       TestController.searchStudent = 'Albert';
                       TestController.searchUsers();
                                                                    //System.debug('Var Student='+TestController.StudentId);               
                       List<User> StudentA = TestController.getAllusers();
                       /* for(user us:StudentA){System.debug(us.name);} */
                       System.assertEquals(StudentA.size(), 0);  
                       
                       //Existent Student
                       TestController.searchStudent = 'StudentC'; 
                                                                    //System.debug('Var Student='+TestController.StudentId);
                       StudentA = TestController.getAllUsers();
                       /* for(user us:StudentA){System.debug(us.name);} */
                       System.assertEquals(StudentA.size(), 1); 
                       
                       Testcontroller.StudentId = null;
                       TestController.Loans     = null;
                       System.assertEquals(Testcontroller.getLoansListSize(), 0);
                           
                       TestController.SearchLoan();
                       Testcontroller.StudentId = StudentA[0].id; 
                                                                    //System.debug( 'StudentA[0].id='+Testcontroller.StudentId);
                       //LendBook
                       TestController.SearchLoan();
                       System.assertEquals(TestController.Loans.size(), 0); 
                       
                       List<Book_Copy__c> BookForStudent = [select Name, Book__r.Name ,active__c from Book_Copy__c where Book__r.Name like '%Dexter 1%' and active__c=true limit 1];
                       //System.debug('List size ='+ BookForStudent.size());
                       //System.debug('BookCopy Id='+ BookForStudent[0].Name+ ' available '+ BookForStudent[0].active__c);
                       System.assertEquals(BookForStudent[0].Book__r.Name, 'Dexter 1');
                       TestController.searchbookcopy = 'B-3455a';
                       TestController.LendBookCopy();
                       TestController.searchbookcopy =  BookForStudent[0].Name;
                       
                       TestController.LendBookCopy();
                       TestController.LendBookCopy();
                       TestController.SearchLoan();
                       //List<Loan__C> LoansForUSer= [select  Name, BookName__c ,Expected_return_date__c from Loan__c where Student__c = :Testcontroller.StudentId and Returned__C = False ];
                       //System.debug('Actual Loans for Student '+Testcontroller.StudentId+', '+ LoansForUSer.size());
                       
                       //Check List size
                       Integer NumberofLoans = TestController.getLoansListSize();
                       System.assertEquals(NumberofLoans,1); 
                       
                       //Return Book
                       List<Loan__C> LoansForUSer 			= TestController.getLoans();
                       Testcontroller.LoanNumber  			= LoansForUSer[0].id;
                       Loan__c UpdateLoan 					= LoansForUSer[0];
                       updateLoan.Loan_Date__c 				= date.Today()-7;
                       updateLoan.Expected_return_date__c 	= date.Today()-3;
                       update updateLoan;
                       TestController.SearchLoan();
                       System.assertEquals(TestController.PendingLoans,true);
                       System.assertEquals(TestController.ShowWarningBlock,true);
                    
                       Testcontroller.ReturnBook();
                       
                       LoansForUSer = TestController.getLoans();
                       System.assertEquals(LoansForUSer.size(),0);
                       
                       TestController.clearLoans();
                    
                    
                }
                catch(Exception e)
                {
                    
                }
                Test.stopTest();
    	}
    }

}