<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_24hs_Before</fullName>
        <description>Send Email to Student</description>
        <protected>false</protected>
        <recipients>
            <field>Student__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Student_Loan24hs</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_if_not_returned</fullName>
        <description>Send Email if not returned</description>
        <protected>false</protected>
        <recipients>
            <field>Student__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Student_Loan24hsafter</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Student</fullName>
        <description>Send Email to Student</description>
        <protected>false</protected>
        <recipients>
            <field>Student__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Student_Loan</template>
    </alerts>
    <rules>
        <fullName>Loan Mails to Student</fullName>
        <actions>
            <name>Send_Email_to_Student</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Loan__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Email_24hs_Before</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Loan__c.Expected_return_date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Email_if_not_returned</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Loan__c.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Return Book</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Loan__c.Returned__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
