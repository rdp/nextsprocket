module StaticPageHelper

  def terms_of_use_text
    txt=<<EOS
You are independently responsible for complying with all applicable laws in all of your actions related to your use of #{t(:'site-name')} services, regardless of the purpose of the use. Your right to access and use of the #{t(:'site-name')} services is subject to your agreement to all of the terms, conditions, policies and notices contained in this agreement. If you do not agree to be bound by the terms of this Agreement, you may not use nor access the #{t(:'site-name')} services.

The #{t(:'site-name')} is not available to prospective users under the age of 13, or to any users suspended or removed from the system by #{t(:'site-name')} for any reason. If you are 13 or over but under the age of majority in your jurisdiction, you must make sure that your parent or guardian reads and accepts this Agreement on your behalf prior to your use of the #{t(:'site-name')} services. If you do not meet these requirements, you may not use the #{t(:'site-name')} services.

<h3>Use of Service</h3>

#{t(:'site-name')} may refuse service without prior notice to any user for any reason or no reason.

If you are a registered user of #{t(:'site-name')}, you are responsible for maintaining the confidentiality of your password, and are fully responsible for all activities that occur under your account with or without your knowledge. If you knowingly provide your password information to another person, your account privileges may be suspended temporarily or terminated. You agree to immediately notify #{t(:'site-name')} of any unauthorized use of your password or any other breach of security. #{t(:'site-name')} will not be liable for any loss or damage arising from your failure to comply with this section.

<h3>User Conduct Rules</h3>

#{t(:'site-name')} reserves the right to reject any activities as we see fit. You may not use the #{t(:'site-name')} service for activities that:
    * Violate any law, statute, ordinance or regulation.
    * Involve the development of products or services identified by government agencies to have a high likelihood of being fraudulent.
    *  To impersonate any person or entity, or otherwise misrepresent your identity
    * To transmit, deliver, upload, display, or otherwise post content in any form, or initiate communications, on the #{t(:'site-name')} which are in violation of any law or regulation, defamatory or libelous, abusive or threatening towards or invasive of the privacy of any third party, obscene, discriminatory, or otherwise objectionable.
    * For any illegal purpose or to advocate illegal activity.
    * To transmit, deliver, upload, display, or otherwise post content that is treated as confidential under any contract or policy or fiduciary relationship.
    * To transmit, deliver, upload, display, or otherwise post content in any form on the #{t(:'site-name')} that infringes upon the proprietary rights of any person, including patents, trademarks, trade secrets, and copyrights.
    * To transmit, deliver, upload, display, or otherwise post content in any form on the #{t(:'site-name')} that includes any unsolicited emails or advertising. This prohibition includes but is not limited to using the #{t(:'site-name')} to connect to people in order to send unsolicited promotional messages, including "junk mail" and "spam".
    * To use technological means (e.g., automated scripts, electronic harvesting means) to collect email addresses, other information of other users, or any other data from the #{t(:'site-name')}.
    * Any unauthorized use of any robot, spider, or other automated device on the #{t(:'site-name')}.
    * Any unauthorized framing of or linking to the #{t(:'site-name')}.
    * To transmit, deliver, upload, display, or otherwise post content in any form on the #{t(:'site-name')} that contains software viruses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of any computer software or hardware or telecommunications equipment.
    * To intimidate, harass, offend, threaten, embarrass, stalk or invade the privacy of any individual or entity.
    * To access or use the #{t(:'site-name')} in a manner that could damage or overburden servers or networks connected to the #{t(:'site-name')}.
    * To solicit personal information from anyone under the age of eighteen (18).

<h3>Jurisdictional Issues</h3>

This site is controlled and operated by #{t(:'site-name')} from its offices within the state of California in the United States of America. #{t(:'site-name')} makes no representation that materials in this site are appropriate or available for use in other jurisdictions. Those who choose to access the #{t(:'site-name')} services from other locations do so on their own initiative and are responsible for compliance with local laws, if and to the extent local laws are applicable. Specifically, you agree to comply with all applicable laws regarding the export of software from the United States or the country in which you reside.

<h3>Information Provided</h3>

The purpose of the #{t(:'site-name')} services is to let people create tasks and pool resources including money for others to provide solutions. As such, you will have the opportunity to submit to us or otherwise provide through the #{t(:'site-name')} services certain content and information about yourself and your business. This content and information will be accessible by and disclosed by all viewers. As such, we ask that you do not disclose any content and/or information which you do not want to become publicly available. You also give up any claim that any use by #{t(:'site-name')} or its licensees of any such content and/or information violates any of your rights, including but not limited to moral rights, privacy rights, rights to publicity, proprietary or other rights, and/or rights to credit for the material or ideas set forth therein.

You understand that all information, messages, or other content posted, displayed, uploaded, downloaded, transmitted, distributed or sent is the sole responsibility of those persons posting, displaying, uploading, downloading, transmitting, distributing or sending the information, message or content and that #{t(:'site-name')} will not be liable for any errors or omissions in any such information, message or content. You understand that #{t(:'site-name')} cannot guarantee the identity of any other users whom you may contact or who may contact you in the course of using the #{t(:'site-name')} service. Additionally, we cannot guarantee the authenticity of any data which users may provide about themselves. Finally we cannot guarantee that other users will use your content and/or information in the manner you intended them to and #{t(:'site-name')} shall not be liable for any third party's use or misuse of your information.

You understand that any of the trademarks, service marks, collective marks, design rights or similar rights that are mentioned, used or cited in the user profile information accessible via the #{t(:'site-name')} Website are the property of their respective owners. Their use on #{t(:'site-name')} does not imply that you may use them for any purpose other than for information.

<h3>Transactions on or through the Site<h3>

#{t(:'site-name')} acts as an intermediary between those who create tasks('Task Creator'), associated task rewarders('Task Rewarders') and those who provide task submissions('task submitters'). The Task Creator has sole authority to deem a task submission as 'completed.' Once 'completed', the task creator and task rewarders are obligated to pay reward amount to the task submitter whose task submission was marked as completed. #{t(:'site-name')} will charge #{COMMISSION_PERCENTAGE} commission fee. The total charge is displayed to the user. The commission fee is subject to change.

THE REWARD AMOUNT IS NOT A GUARANTEE AMOUNT. #{t(:'site-name')} CANNOT GUARANTEE THE COLLECTION OF THE REWARD DUE TO FAILURES IN PAYMENT PROCESSING OR REFUSAL TO PAY.

During the task creation, Task Creator may preapprove certain payment amounts via Paypal.  This preapproval is still not a guarantee of the payment and #{t(:'site-name')} is not liable for any such failure of payment.

If a task is deemed to be 'rejected' or 'expired', #{t(:'site-name')} will not charge any commission fees.

Once a task is marked 'completed', and the Task Creator/Task Rewarder issues the payment to the task submitters, there will be no refunds. You agree that #{t(:'site-name')} is not responsible for any damage or loss incurred as a result of any such dealings. #{t(:'site-name')} is under no obligation to become involved in disputes between task creators, task rewarders and task submitters or between Site users and any third party. #{t(:'site-name')} reserves the right to remove any task or task submission from the Site at any time for any reason.

Additionally, once a task is marked 'paid', the task submission will be visible to the public and the task submitter agrees for the task submission to become open source under the selected open source license. If no open source license is selected, the task submission will follow the <a href="http://www.opensource.org/licenses/mit-license.php">MIT license</a> by default.

<h3>Termination</h3>

You agree that #{t(:'site-name')} may, with or without cause, immediately terminate the #{t(:'site-name')} services, your #{t(:'site-name')} account and/or ask you to stop using the #{t(:'site-name')}, and, if necessary, prevent your access to the #{t(:'site-name')}. Without limiting the foregoing, the following may lead to a termination by #{t(:'site-name')} of a user's use of the #{t(:'site-name')} Website: (a) breaches or violations of this Agreement or other incorporated guidelines, including but not limited to user conduct guidelines, or (b) requests by law enforcement or other government agencies. Upon termination or a request to discontinue use by #{t(:'site-name')}, you shall have no further rights to use the #{t(:'site-name')}. Furthermore, you agree that all such terminations shall be made in #{t(:'site-name')}'s sole discretion and that #{t(:'site-name')} shall not be liable to you nor any third-party for any termination of your account or access to the #{t(:'site-name')} services.

<h3>Digital Millennium Copyright Act</h3>

Response to Notice. If you believe that your copyrighted work is being infringed, #{t(:'site-name')} will respond to a notice received by its DMCA agent specified below ("Notice") if it contains substantially the following:

    * A physical or electronic signature of a person (the "Complaining Party") authorized to act on behalf of the owner of the copyright that is allegedly infringed;
    * Identification of the copyrighted work claimed to have been infringed, or, if multiple copyrighted works at a single online site are covered by a single Notice, a representative list of such works at that site;
    * Identification of the material that is claimed to be infringing or to be the subject of infringing activity and that is to be removed or access to which is to be disabled, and information reasonably sufficient to permit #{t(:'site-name')} to locate the material;
    * The Complaining Party's name, address, telephone number and email address;
    * A statement that the Complaining Party has a good faith belief that the use of the material in the manner complained of is not authorized by the copyright owner, its agent, or the law; and
    * A statement that the information in the Notice is accurate, and under penalty of perjury, that the Complaining Party is authorized to act on behalf of the copyright owner.

In the event that #{t(:'site-name')}'s DMCA agent receives such a Notice, #{t(:'site-name')} will, in accordance with the DMCA, expeditiously remove or disable access to the material that is alleged to be infringing. In addition, to avoid any liability to the user for mistakenly removing or disabling access to the user's material, #{t(:'site-name')} will also: (i) forward the Notice to the user; and (ii) take reasonable steps to promptly notify the user that it has removed or disabled access to the material.

The DMCA permits users to contest the removal or disabling of access to their material by sending a written notice ("Counter Notification") to the DMCA agent. To be valid, a Counter Notification must include substantially the following:

   1. The user's physical or electronic signature;
   2. Identification of the material that has been removed or to which access has been disabled and the location at which the material appeared before it was removed or access to it was disabled;
   3. A statement under penalty of perjury that the user has a good faith belief that the material was removed or disabled as a result of mistake or misidentification of the material to be removed or disabled;
   4. The user's name, address, and telephone number; and
   5. A statement that the user consents to the jurisdiction of the Federal District Court for the judicial district in which user's address is located, or if the user's address is outside the United States, for any judicial district in which #{t(:'site-name')} may be found, and that the user will accept service of process from the Complaining Party or an agent of such person.

Upon receipt by its DMCA agent of a valid Counter Notification, #{t(:'site-name')} will, in accordance with the DMCA:

   1. Promptly provide the Complaining Party with a copy of the Counter Notification;
   2. Inform the Complaining Party that it will replace the removed material or cease disabling access to it in ten (10) business days; and
   3. Replace the removed material and cease disabling access to it within ten (10) to fourteen (14) business days following receipt of the Counter Notification, provided that #{t(:'site-name')}'s DMCA agent has not received notice from the Complaining Party that an action has been filed seeking a court order to restrain the user from engaging in infringing activity relating to the material on #{t(:'site-name')}'s site.

#{t(:'site-name')}'s designated DMCA agent is:
#{t(:'site-name')}
5 San Leon
Irvine, CA 92606
copyright@nextsprocket.com

<h3>Indemnification</h3>

By accepting this Agreement, you agree to indemnify and otherwise hold harmless #{t(:'site-name')}, its officers, directors, owners, agents, employees, information providers, affiliates, licensors, licensees and other partners from any (collectively, "Indemnified Parties") from and against any and all liability and costs including, without limitation, attorneys' fees and costs, incurred by the Indemnified Parties in connection with any claim arising out of (i) any breach by you of this Agreement; (ii) any content, information, property, products, services and/or activities offered by you or accepted by you as a result of using the #{t(:'site-name')}, or (iii) any other matter relating to your use of the #{t(:'site-name')}. Any business transactions which may arise between users from their use of #{t(:'site-name')} are the sole responsibility of the users involved.

<h3>Disclaimers</h3>

THE #{t(:'site-name')} SERVICES AND ALL MATERIAL CONTAINED THEREON ARE PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS. #{t(:'site-name')} ASSUMES NO RESPONSIBILITY FOR THE ACCURACY OR CONTENT BETWEEN USERS. #{t(:'site-name')} EXPRESSLY DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO WARRANTIES OF TITLE OR NON-INFRINGEMENT, OR THE IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, OTHER THAN THOSE WARRANTIES WHICH ARE INCAPABLE OF EXCLUSION, RESTRICTION OR MODIFICATION UNDER THE LAWS APPLICABLE TO THIS AGREEMENT.

#{t(:'site-name')} MAKES NO WARRANTY THAT (i) THE #{t(:'site-name')} WEBSITE WILL BE UNINTERRUPTED, TIMELY, SECURE, OR ERROR-FREE OR THAT ANY ERRORS IN THE SOFTWARE WILL BE CORRECTED OR (ii) THE QUALITY, VALIDITY OR LEGALITY OF ANY CONTENT, INFORMATION, PROPERTY, PRODUCTS, SERVICES AND/OR ACTIVITIES PURCHASED, OBTAINED OR PARTICIPATED IN BY YOU FROM OR WITH OTHER USERS OF OR ADVERTISERS ON THE #{t(:'site-name')} WEBSITE WILL MEET YOUR EXPECTATIONS.

<h3>Limitation of Liability</h3>

THE DISCLAIMERS OF LIABILITY CONTAINED IN THIS SECTION APPLY TO ANY DAMAGES OR INJURY CAUSED BY ANY FAILURE OF PERFORMANCE, ERROR, OMISSION, INTERRUPTION, DELETION, DEFECT, DELAY IN OPERATION OR TRANSMISSION, COMPUTER VIRUS, COMMUNICATION LINE FAILURE, THEFT OR DESTRUCTION OR UNAUTHORIZED ACCESS TO, ALTERATION OF, OR USE OF THE #{t(:'site-name')} SERVICES, WHETHER FOR BREACH OF CONTRACT, TORTIOUS BEHAVIOR, NEGLIGENCE, OR UNDER ANY OTHER CAUSE OF ACTION.

#{t(:'site-name')} DOES NOT ENDORSE, WARRANT OR GUARANTEE ANY PRODUCT OR SERVICE AND #{t(:'site-name')} WILL NOT BE A PARTY TO OR IN ANY WAY MONITOR ANY TRANSACTION BETWEEN YOU AND THIRD PARTY PROVIDERS OF PRODUCTS OR SERVICES. AS WITH THE PURCHASE OF A PRODUCT OR SERVICE THROUGH ANY MEDIUM OR IN ANY ENVIRONMENT, YOU SHOULD USE YOUR BEST JUDGMENT AND EXERCISE CAUTION WHERE APPROPRIATE.

IF YOU HAVE A DISPUTE WITH ONE OR MORE OF OUR MEMBERS, YOU HEREBY RELEASE US (AND OUR OFFICERS, DIRECTORS, OWNERS, AGENTS, AFFILIATES, EMPLOYEES AND AGENTS) FROM ANY CLAIMS, DEMANDS AND DAMAGES (ACTUAL AND CONSEQUENTIAL) OF EVERY KIND AND NATURE, KNOWN AND UNKNOWN, ARISING OUT OF OR IN ANY WAY CONNECTED WITH SUCH DISPUTE.

<h3>Paypal Acceptable Use</h3>

By using #{t(:'site-name')} services, you abid by Paypal's <a href="https://cms.paypal.com/us/cgi-bin/marketingweb?cmd=_render-content&content_ID=ua/AcceptableUse_full&locale.x=en_US">Acceptable Use Policy</a> as well.
EOS
  end

  def privacy_policy_text
    txt=<<EOS
<h3>Privacy Policy</h3>

By accessing and using #{t(:'site-name')} services, you acknowledge and agree to all of the terms and conditions of our Privacy Policy and our Terms of Service.

<h3>Collected Information</h3>

Certain sections of #{t(:'site-name')} services require you to be become a registered user and submit personally identifiable information to #{t(:'site-name')} including name, email and password.

#{t(:'site-name')} will collect relevant information to the posted task. All information collected at this stage is publicity viewable.

#{t(:'site-name')} may use cookies to collect usage information. You can refuse all cookies in your web browser's settings but some features may not operate correctly.

Like most websites, PeopleJar uses cookies and web log files to track site usage. A cookie is a small data file which resides on your hard drive which allows PeopleJar to recognize your computer when you return to the PeopleJar Website. Unfortunately, if your browser settings do not allow cookies, you may not be able to use the PeopleJar Website.

<h3>Our Policy on Children Under the Age Of 13</h3>

Children under the age of 13 are not eligible to use #{t(:'site-name')} services. We ask that minors (i.e. persons under the age of 18 or the age of majority in your jurisdiction) not submit any personal information to us or use the service without the express consent of their parent or guardian and then only after such parent or guardian has reviewed and agreed to our Terms of Service and this Privacy Policy.

<h3>Archives</h3>

#{t(:'site-name')} may keep copies of user information and content provided by users. This may include past versions which are marked deleted or otherwise modified.

<h3>Security</h3>

We have put physical and managerial procedures into place in order to help safeguard and prevent unauthorized access, use and/or disclosure of your personal information. Although we use reasonable efforts to safeguard the security of your personal information, transmissions made on or through the Internet and personal information stored on our servers or the servers of third parties that we use are vulnerable to attack and cannot be guaranteed to be secure.

While #{t(:'site-name')} takes reasonable precautions against possible breaches in the #{t(:'site-name')} Website and customer databases, no website or Internet transmission is completely secure. Consequently, #{t(:'site-name')} cannot and does not guarantee that unauthorized access, hacking, data loss, or other breaches will never occur. #{t(:'site-name')} urges you to take steps to keep your personal information safe by memorizing your password or keeping it in a safe place, logging out of your user account, and closing your web browser.

<h3>Changes to This Privacy Policy</h3>

We reserve the right to change this Privacy Policy at any time by notifying registered users via e-mail of the existence of a new Privacy Policy and/or posting the new Privacy Policy on the PeopleJar Website. All changes to the Privacy Policy will be effective when posted, and your continued use of #{t(:'site-name')} services after the posting will constitute your acceptance of, and agreement to be bound by, those changes.

<h3>Questions or Comments</h3>

If you have questions or comments about this privacy policy, please email us at <a href="mailto:privacy*at)nextsprocket.com">privacy*at)nextsprocket.com</a>
EOS
  end
end