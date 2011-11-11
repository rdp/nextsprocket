module PaymentsHelper
  def show_total_amount_with_commission_js(textfield_element, total_amount_element)
    js =<<EOS
  function showTotalAmountWithCommission(textfieldElement, totalAmountElement){
    var userDefinedAmount = parseFloat(textfieldElement.val());
    var commissionAmount = #{COMMISSION_PERCENTAGE}*userDefinedAmount;
    var totalAmount = userDefinedAmount + parseFloat(commissionAmount.toFixed(2));
    if(typeof userDefinedAmount == 'number' && isFinite(userDefinedAmount))
      totalAmountElement.html('$' + totalAmount);
    else
      totalAmountElement.html("$");   
  }
$('##{textfield_element}').keyup(function(){
   showTotalAmountWithCommission($('##{textfield_element}'), $('##{total_amount_element}') );
   })
   showTotalAmountWithCommission($('##{textfield_element}'), $('##{total_amount_element}') );
EOS

    "$(document).ready(function() {#{js} } );"
  end
end
