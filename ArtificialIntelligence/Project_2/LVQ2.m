clc; clear;
fid = fopen('IRIS.TXT');
junk = fgetl(fid);
junk = fscanf(fid,'%s',1);
nin = fscanf(fid,'%d',1); %nin = number of inputs
junk = fscanf(fid,'%s',1);
nout = fscanf(fid,'%d',1); %nout = number of outputs
junk = fscanf(fid,'%s',1);
nrpat = fscanf(fid,'%d',1); %nrpat = number of patterns
A = fscanf(fid,'%f',[nin+nout,Inf]); %A = [I/O pairs]
fclose(fid);
x = A(1:nin,:); %x = input patterns as column vectors
d = A(nin+1:nin+nout,:); %d = desired output vector

%for the wine.txt
% tstpats=18;
% valpats=36;
% trpats=124;

%for the iris.txt
tstpats=15;
valpats=30;
trpats=105;

Ppc=[1, 2, 5];
Epoch=[5, 10, 15];
Ka=[0.01, 0.1];
a0=0.5;
s=0.6;

Results=table('Size',[18 7],'VariableTypes',{'int8','int8','double','double','double','double','double'},'VariableNames',{'Ppc','Epoch','Ka','Train_Accuracy','Validation_Accuracy','Test_Accuracy','Time'});
iR=0;%result table counter

for i=1:10  %anakatema dataset
    idx=randperm(nrpat);
    X=x(:,idx);
    D=d(:,idx);
end

D=vec2ind(D);
%main
for p= 1:length(Ppc)
    ppc=Ppc(p);

    W=zeros(nin, nout*ppc); %βάρη
    L=[]; %labels βαρών
    for i=1:ppc
        L=[L,[1:3]];
    end    
   
    for e=1:length(Epoch)
        epoch=Epoch(e);

        for a=1:length(Ka)            
            meanAcc=0;
            iR=iR+1; %result table counter
            meanAccuracyTrPerFold=zeros(10,1);
            accuracyVal=zeros(10,1);
            accuracyTest=zeros(10,1);           
            tic

            %crossvalidation
            for f=1:10
                at=a0;
                idxtr = mod((f-1)*trpats:(f-1)*trpats + trpats -1,nrpat)+1;
                idxval = mod(idxtr(trpats):idxtr(trpats) + valpats -1,nrpat)+1;
                idxtest = mod(idxval(valpats):idxval(valpats) + tstpats -1, nrpat)+1;
        
                X_train = X(:,idxtr);
                D_train = D(:,idxtr);
                X_val = X(:,idxval);
                D_val = D(:,idxval);
                X_test = X(:,idxtest);
                D_test = D(:,idxtest);
                k=1;
                for c=1:ppc*nout %arxikopoiisi W
                    while D_train(k)~=L(c)
                        k=k+1 ; 
                    end
                    W(:,c)=X_train(:,k);
                end
                accuracy=zeros(epoch,1);
                
                %start training the lvq2 algorithm
                for i = 1:epoch %start of the epoch
    
                    for j = 1:length(X_train) %Loop for the input data
    
                        t=(epoch-1)* length(X_train) + j -1;                    
                        Dist = vecnorm(X_train(:,j) - W); % Finds the Distances for the x(j)
                        
                        %find the closest prototypes
                        sortedDist = sort(Dist);
                        min1 = sortedDist(1); %first closest
                        min2 = sortedDist(2); %second closest
                        id1=find(Dist==min1,1); %position in Dist for the min1
                        id2=find(Dist==min2,1); %position in Dist for the min2
                        
                        if D_train(j)~=L(id1) && D_train(j)==L(id2) %the class of the x(j) must be different with the class of the closest W, L(id1) AND the same with the next closest L(id2)                      
                            if min(Dist(id1)/Dist(id2) , Dist(id2)/Dist(id1)) >1-s && max(Dist(id1)/Dist(id2) , Dist(id2)/Dist(id1)) <1+s %the x(j) must be between the 2 W
                                %update w                            
                                W(:,id1)=W(:,id1) - at * ( X_train(:,j) - W(:,id1) ); %first closest w
                                W(:,id2)=W(:,id2) + at * ( X_train(:,j) - W(:,id2) ); %second closest w
                            end
                        end                        
                    end
                    
                    %Training prediction for each epoch
                    corr_pred=0;
                    for j = 1:length(X_train)                        
                        
                        Distance = vecnorm(X_train(:,j) - W);                    
                        id=find(Distance==min(Distance));    
                        if D_train(j)==L(id)
                            corr_pred=corr_pred+1; %correct predictions
                        end
    
                    end
                    accuracy(i)=corr_pred / length(X_train) * 100; %accuracy for this epoch
                    at=a0/(1+Ka(a)*t);
                    
    
                end %end of the lvq2 algorithm
                
                meanAccuracyTrPerFold(f)=mean(accuracy); %accuracy for this fold

                %validation accuracy for this fold
                corr_pred=0;
                for j = 1:length(X_val)                        
                    Distance = vecnorm(X_val(:,j) - W);                    
                    id=find(Distance==min(Distance));    
                    if D_val(j)==L(id)
                        corr_pred=corr_pred+1; %correct predictions
                    end    
                end
                accuracyVal(f)=corr_pred / length(X_val) * 100;

                %test accuracy for this fold
                corr_pred=0;
                for j = 1:length(X_test)                        
                    Distance = vecnorm(X_test(:,j) - W);                    
                    id=find(Distance==min(Distance));    
                    if D_test(j)==L(id)
                        corr_pred=corr_pred+1; %correct predictions
                    end    
                end
                accuracyTest(f)=corr_pred / length(X_test) * 100;               
            end
            time=toc;
            
            meanTrAcc=mean(meanAccuracyTrPerFold);
            meanValAcc=mean(accuracyVal);
            meanTsAcc=mean(accuracyTest);
            Results(iR,:)={ppc,epoch,Ka(a),meanTrAcc,meanValAcc,meanTsAcc,time};           
        end        
    end
end
