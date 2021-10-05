class SigleLinkedListNode:
    def __init__(self, data, next=None):
        self.data = data
        self.next = next


h1 = SigleLinkedListNode(0, None)
h2 = SigleLinkedListNode(-1, None)

head1 = h1
head2 = h2

for i in range(0, 3, 1):
    h1.next = SigleLinkedListNode(i+1, None)
    h1 = h1.next
for i in range(1, 4, 1):
    h2.next = SigleLinkedListNode(i+1, None)
    h2 = h2.next

def mergeLists(head1, head2):
    res = SigleLinkedListNode(0)
    resHead = res
    
    while(head1 != None and head2 != None):
        if head1.data < head2.data:
            res.next = head1
            res = res.next
            head1 = head1.next
        else:
            res.next = head2
            res = res.next
            head2 = head2.next
    if head1 == None:
        res.next = head2
    if head2 == None:
        res.next = head1
    
    return resHead.next
        
merged = mergeLists(head1, head2)

while merged != None:
    print(merged.data)
    merged = merged.next
    