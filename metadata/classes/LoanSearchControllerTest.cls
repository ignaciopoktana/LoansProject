@isTest
public class LoanSearchControllerTest
{
     static testMethod void pruebaUsers()
    {
        /*List<User> usuarios = new LoanSearchController().getAllUsers();
        System.debug('Tamanio='+usuarios.size());
        system.assertEquals(usuarios.size(), 9);*/
        
        Book__c newBook = New Book__c();
        newBook.Name = 'Dexter';
        newBook.Author__c = 'Gendy Tartakovsky';
        newBook.Description__c = 'Genius kid';
        newBook.Publisher__c = 'Cartoon Network';
        insert newBook;
        
        Book_Copy__c newBookCopy = new Book_Copy__c();
        newBookCopy.Book__c		 = newBook.id;
        insert newBookCopy;
        
        Test.startTest();
        try
        {
           String UserName = 'LibrarianUser@TestOktana.io';
            // This code runs as the system user
            Profile prof = [SELECT Id FROM Profile WHERE Name='Librarian'];
            User userLib = new User(
                                    Alias 				= 'LibTest1', 
                                    Email				='LibrarianUser@TestOktana.io',
                                    EmailEncodingKey	='UTF-8', 
                                    LastName			='Testing', 
                                    LanguageLocaleKey	='en_US',
                                    LocaleSidKey		='en_US', 
                                    ProfileId 			= prof.Id,
                                    TimeZoneSidKey		='America/Los_Angeles',
                                    UserName			=UserName
                                    ); 
            Insert userLib;
            
            UserName = 'StudentAUser@TestOktana.io';
            // This code runs as the system user
            prof = [SELECT Id FROM Profile WHERE Name='Student'];
            User userA = new User(
                                    Alias 				='StuaTest1', 
                                    Email				='StuaUser@TestOktana.io',
                                    EmailEncodingKey	='UTF-8',
                					FirstName			='StudentA',
                                    LastName			='Testing', 
                                    LanguageLocaleKey	='en_US',
                                    LocaleSidKey		='en_US', 
                                    ProfileId 			= prof.Id,
                                    TimeZoneSidKey		='America/Los_Angeles',
                                    UserName			=UserName
                                    ); 
            Insert UserA;
            
            User userB = new User(
                                    Alias 				='StuBTest1', 
                                    Email				='StuBUser@TestOktana.io',
                                    EmailEncodingKey	='UTF-8',
                					FirstName			='StudentB',
                                    LastName			='Testing', 
                                    LanguageLocaleKey	='en_US',
                                    LocaleSidKey		='en_US', 
                                    ProfileId 			= prof.Id,
                                    TimeZoneSidKey		='America/Los_Angeles',
                                    UserName			=UserName
                                    ); 
            Insert UserB;
            
            System.runAs(userLib)
            {
               //ApexPages.currentPage().getParameters().put('Student1',objLeadCenter.id);
			   LoanSearchController TestController = new LoanSearchController();
              // TestController.setSearchStudent('Student1'); 
              // List<User> StudentA = TestController.getAllUsers();
              // System.assertEquals(StudentA.size(), 0); 
            }
        }
        catch(Exception e)
        {
            
        }
        Test.stopTest();
    }

}