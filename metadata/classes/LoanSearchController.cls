public with sharing class LoanSearchController 
{
    public string searchStudent	 			{get;set;}
    public string StudentId		 			{get;set;}
    public list<Loan__c> Loans	 			{get;set;}
    public list<User> AllUsers   			{set;}
    private String QueryPart;
    public integer LoansListSize 			{set;}
    public string  LoanNumber    			{get;set;}
    public string  CurrentStudent			{get;set;}
    public boolean PendingLoans  			{get;set;}
    public boolean StudentFound  			{get;set;}
    public boolean ShowWarningBlock  		{get;set;}
    public boolean ShowLoansList	  		{get;set;}
	public String  SearchBookCopy 			{get;set;}
    
    public list<Loan__c> getLoans()
    {
       SearchLoan();
        system.debug('Load Loans');
       return this.Loans;       
    }
    public integer getLoansListSize()
    {
        if(Loans==null)
        {
            return 0;
        }
        else 
        {
            return this.Loans.size();            
        }
        
    }
    public list<User> getAllUsers()
    {	//System.debug('Execute getAllUsers');
        PendingLoans 		= true;
        StudentFound 		= false;
        ShowWarningBlock 	= false;
        QueryPart 			= '';
        Loans = new List<Loan__c>() ;
        Profile prof    	= [select id from profile where name = 'Student'];
        String QueryPart1 = prof.Id;
        if(searchStudent==null)
           {searchStudent='';}
        if(searchStudent!='')
        {
			System.debug('searchStudent ='+searchStudent);
            QueryPart = ' where Name like \'%'+searchStudent+'%\'';           
        }
                        
                
     		System.debug(QueryPart);
            return Database.query('select Id,Name from User where profileId=\''+QueryPart1+'\' '+ QueryPart+' order by Name asc limit 20');
    	   	//return Database.query('select Id,Name from User where Profileid = :\''+QueryPart1+'\''+QueryPart+' order by Name asc limit 20');
     		
    }
    
    
    public pageReference searchUsers()
    {
        	System.debug('pageReference searchUsers');
        	getallusers();     	
        	return null; 
    }
    

    public pageReference SearchLoan()
    {
        
        System.debug('Start SearchLoan for student '+StudentId);
        //System.debug('StudentId =');
        PendingLoans     = false;
        ShowWarningBlock = false;
        if(StudentId==null)
        {
            StudentId='';
        }
        System.debug('StudentId='+StudentId);
        String Results = 'select  Name, BookName__c ,Expected_return_date__c from Loan__c where Student__c =\''+StudentId+'\' and Returned__C = False'; 
            
        	try
            {

                User GetName 	= [select  Name from User where Id = :StudentId ];
                CurrentStudent 	= 'Student: '+GetName.Name;
                StudentFound	= True;
                Loans 			= Database.query(Results + ' order by BookName__c asc limit 20');
                System.debug('Check Loans size='+Loans.size());
                if(Loans.size()>0)
                {
                	ShowLoansList   = true;
                }
                for(Loan__c checkDate:Loans)
                {
                    if(checkDate.Expected_return_date__c < date.Today())
                    {
                       PendingLoans		= true;
                       ShowWarningBlock	= true;
                       System.debug('PEnding loans true');
                       
                    } 
                    
                }    
                System.debug('ShowWarningBlock '+ShowWarningBlock);
            }
            catch(Exception e)
            {
                System.debug('Catch'+ApexPages.Severity.ERROR);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Something Went Wrong, check the Log'));
                
            }
        	
    return null; 
    }
    
    
    public PageReference clearLoans()
    {
        
        Loans.clear();
        StudentId = '';
        PendingLoans     = true;
        ShowLoansList    = false;
        ShowWarningBlock = false;
        getAllUsers();
        System.debug('Cleaning, loans size'+Loans.size());
        return null;
    }
    
    
    public void ReturnBook()
    {
        System.debug('Returnbook, id='+LoanNumber);
        Loan__c ToBeReturned = [Select Name, Returned__c from Loan__c where id=:+LoanNumber and Returned__c = false];
        ToBeReturned.Returned__c = True;
		
        if(ToBeReturned!=null){
            Database.update(ToBeReturned);
            SearchLoan();
        }    
    }
    
    public pageReference LendBookCopy()
    {
        System.debug('LendBook');
        
        try
        {
            Book_Copy__c checkBook = [select name,Active__c from Book_Copy__c where Name=:+SearchBookCopy];
            if(checkBook.Active__c==false)
            {
                System.debug('LendBook active false');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'That Book is not Available'));
                
            }
            else
            {
                System.debug('LendBook active true');
                System.debug('StudentID for loan'+StudentId);
                Loan__C BookToBook 					= new Loan__c();
                BookToBook.Book_Copy__c 			= checkBook.Id;
                BookToBook.Student__c				= StudentId;
                BookToBook.Loan_Date__c				= date.today();
                BookToBook.Expected_return_date__c 	= date.today()+ 3;
                BookToBook.Returned__c				= false;
                insert BookToBook ;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The Loan has been Registered'));
            }
        }
        catch(Exception ex)
        {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'That Book does not Exist')); 
        }
        return null;
    }
   
    
}