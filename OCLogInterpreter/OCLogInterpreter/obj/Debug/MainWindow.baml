   M S B A M L   `   `   `  ����  OCLogInterpreter!    OCLogInterpreter.MainWindow   5   	   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	     � Title$  Interpreter��5   	   $	��388��6   $	��672��6*    � 
ResizeMode$ CanMinimize=�66   .��5      �  � ColumnDefinitions 5   
   �� 5      $
��100* �6   �� 5      $
��100* �6   �� 5	      $
��100* �6   .+�5   
   `� $��3��6   .�5      c� .@�5      �� -   5        $
��Open��5      6>   �� 5      -   5        $��
Export CSV��5      6F   5      5      �� 5   
   -   5         ��Name$ DateFilterTB��5      $��23��6(   $��
10,61,10,0q�64    �� TextWrapping$
 Wrap=�6H   $	��Top=�6\    � ToolTip$( "Can be dd/mm/yy, hh:mm:ss or both.��6�   �� 5   
   $��Filter Date/Time:��6   $
��Left=�6,   $��	10,30,0,0q�6G   $	��Top=�6Z   �� 5   
   $��Filter Priority:��6   $
��Left=�6+   $��	10,89,0,0q�6F   $	��Top=�6Y   �� 5   
   -   5         ��Name$ FilterCB��5      $��Filter��6%   $
��Left=�66   $��
10,147,0,0q�6Q   $	��Top=�6e   6�   �� 5   
   -   5         ��Name$ PriorityFilterDD��5      $��10,120,10,0q�6-   $	��Top=�6B   6Z   �� 5   
   -   5         ��Name$ SelTimeDateLab��5      $��
Date/Time:��6(   $��2��6=   $
��Left=�6M   $��	10,10,0,0q�6h   $	��Top=�6{   �� 5   
   -   5        $ SelPriorityLab��5      $��	Priority:��6(   $��2��6<   $
��Left=�6L   $��	10,36,0,0q�6g   $	��Top=�6z   �� 5   
   -   5        $ 	SelInfoTB��5      $��2��6%   $��10,67,10,10q�65   $
 Wrap=�6J   $
��Info��6^   {�.  6j   �� 5   
   -	   5        	 ��Name$	 EntriesView��5      $��1��6'   $��10q�67   6C   5      5      